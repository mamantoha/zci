desc 'Read categories/section/articles from Zendesk and upload resource files to Crowdin'
command :'import:sources' do |c|
  c.desc 'Directory of resource files'
  c.long_desc <<-EOS.strip_heredoc
    This is the directory where the project's files will be store.
  EOS
  c.default_value 'resources'
  c.arg_name 'dir'
  c.flag [:resources_dir]

  c.action do |global_options, options, args|
    resources_dir = File.join(File.dirname(global_options[:config]), options[:resources_dir])

    unless File.exists?(resources_dir)
      FileUtils.mkdir(resources_dir)
    end

    @cli_config['categories'].each do |category|
      zendesk_url = category.fetch('brand_url', @cli_config['zendesk_base_url'])

      zendesk_client = ZCI.initialize_zendesk_client(
        zendesk_url,
        @cli_config['zendesk_username'],
        @cli_config['zendesk_password'],
        global_options[:verbose]
      )

      # Source Category
      source_category_id = category['zendesk_category'].to_i

      # Check if Category exists in Zendesk
      source_category = zendesk_client.hc_categories.find(id: source_category_id)

      if source_category.nil? || source_category.id != source_category_id
        puts "[Zendesk] No category with id #{source_category_id}"
        next
      end

      category_xml = build_category_xml(source_category)
      category_hash = build_category_hash(source_category).merge({ xml: category_xml })

      # Get category's sections in Zendesk
      puts "[Zendesk] Get sections for Category with id #{source_category_id}"
      sections = source_category.sections

      sections_builder = []
      sections.each do |section|
        section_xml = build_section_xml(section)

        unless section_xml.nil?
          sections_builder << build_section_hash(section).merge({ xml: section_xml })
        end
      end

      # Get articles for each section
      articles_builder = []
      sections.each do |section|
        puts "[Zendesk] Get articles for Section with id #{section.id}"
        articles = section.articles

        articles.each do |article|
          article_xml = build_article_xml(article)

          unless article_xml.nil?
            articles_builder << build_article_hash(article).merge({ xml: article_xml })
          end
        end
      end

      crowdin_project_info = @crowdin.project_info
      remote_project_tree = get_remote_files_hierarchy(crowdin_project_info['files'])

      resources_category_dir = File.join(resources_dir, source_category_id.to_s)

      unless File.exists?(resources_category_dir)
        FileUtils.mkdir(resources_category_dir)
      end

      # Create directory for Category on Crowdin if it does not exist yet
      unless remote_project_tree[:dirs].include?("/#{source_category_id}")
        puts "[Crowdin] Create directory `#{source_category_id}`"
        @crowdin.add_directory(source_category_id.to_s)
        @crowdin.change_directory(source_category_id.to_s, title: source_category.attributes[:name])
      end

      # Create xml file for category and upload to Crowdin
      file_name = "category_#{category_hash[:id]}.xml"

      o = File.new(File.join(resources_category_dir, file_name), 'w')
      o.write(category_hash[:xml].to_xml)
      o.close

      files = [
        {
          source:         File.join(resources_category_dir, file_name),
          dest:           File.join(source_category_id.to_s, file_name),
          export_pattern: '/%locale%/%original_path%/%original_file_name%',
          title:          category_hash[:name]
        }
      ]

      if remote_project_tree[:files].include?("/#{source_category_id}/#{file_name}")
        puts "[Crowdin] Update category file `#{file_name}`"
        @crowdin.update_file(files, type: 'webxml')
      else
        puts "[Crowdin] Add category file `#{file_name}`"
        @crowdin.add_file(files, type: 'webxml')
      end

      # Creates xml files for sections and upload to Crowdin
      sections_builder.each do |section|
        file_name = "section_#{section[:id]}.xml"

        o = File.new(File.join(resources_category_dir, file_name), 'w')
        o.write section[:xml].to_xml
        o.close

        files = [
          {
            source:         File.join(resources_category_dir, file_name),
            dest:           File.join(source_category_id.to_s, file_name),
            export_pattern: '/%locale%/%original_path%/%original_file_name%',
            title:          section[:name]
          }
        ]

        if remote_project_tree[:files].include?("/#{source_category_id}/#{file_name}")
          puts "[Crowdin] Update section file `#{file_name}`"
          @crowdin.update_file(files, type: 'webxml')
        else
          puts "[Crowdin] Add section file `#{file_name}`"
          @crowdin.add_file(files, type: 'webxml')
        end
      end

      # Creates xml files for articles and upload to Crowdin
      articles_builder.each do |article|
        file_name = "article_#{article[:id]}.xml"

        o = File.new(File.join(resources_category_dir, file_name), 'w')
        o.write article[:xml].to_xml
        o.close

        files = [
          {
            source:         File.join(resources_category_dir, file_name),
            dest:           File.join(source_category_id.to_s, file_name),
            export_pattern: '/%locale%/%original_path%/%original_file_name%',
            title:          article[:title]
          }
        ]

        if remote_project_tree[:files].include?("/#{source_category_id}/#{file_name}")
          puts "[Crowdin] Update article file `#{file_name}`"
          @crowdin.update_file(files, type: 'webxml')
        else
          puts "[Crowdin] Add article file `#{file_name}`"
          @crowdin.add_file(files, type: 'webxml')

        end
      end
    end # @cli_config['categories'].each
  end
end
