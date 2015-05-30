desc 'Add or update localized resource files(sections and articles) in Zendesk'
command :'export:translations' do |c|
  c.desc 'Directory of resource files'
  c.long_desc <<-EOS.strip_heredoc
    This is the directory where the project's files will be store.
  EOS
  c.default_value 'resources'
  c.arg_name 'dir'
  c.flag [:resources_dir]

  c.action do |global_options, options, args|
    resources_dir = File.join(File.dirname(global_options[:config]), options[:resources_dir])

    @cli_config['categories'].each do |category|
      @zendesk.locales.select { |locale| !locale.default? }.each do |locale|
        if lang = category['translations'].detect { |tr| tr['zendesk_locale'] == locale.locale }
          section_xml_files = Dir["#{resources_dir}/#{lang['crowdin_language_code']}/#{category['zendesk_category']}/section_*.xml"]
          article_xml_files = Dir["#{resources_dir}/#{lang['crowdin_language_code']}/#{category['zendesk_category']}/article_*.xml"]

          all_sections = []
          all_articles = []

          # Read sections from XML files
          section_xml_files.each do |file|
            section_xml_file = File.read(file)
            section = parse_section_xml(section_xml_file)
            all_sections << section
          end

          # Read articles from XML filse
          article_xml_files.each do |file|
            article_xml_file = File.read(file)
            article = parse_article_xml(article_xml_file)
            all_articles << article
          end

          ### Sections
          #
          sections = @zendesk.sections
          all_sections.each do |section_hash|
            if section = sections.find(id: section_hash[:id])
              if section_tr = section.translations.detect { |tr| tr.locale == locale.locale }
                section_tr.update(name: section_hash[:name], description: section_hash[:description])
                if section_tr.changed?
                  section_tr.save
                  puts "[Zendesk] Update `#{lang['crowdin_language_code']}` language translation for Section\##{section.id}."
                end
              else
                section_tr = section.translations.build(locale: locale.locale, name: section_hash[:name], description: section_hash[:description])
                section_tr.save
                puts "[Zendesk] Create `#{lang['crowdin_language_code']}` language translation for Section\##{section.id}."
              end
            end
          end

          ### Articles
          #
          all_articles.each do |article_hash|
            if section = sections.find(id: article_hash[:section_id])
              if article = section.articles.find(id: article_hash[:id])
                if article_tr = article.translations.detect { |tr| tr.locale == locale.locale }
                  article_tr.update(title: article_hash[:title], body: article_hash[:body])
                  if article_tr.changed?
                    article_tr.save
                    puts "[Zendesk] Update `#{lang['crowdin_language_code']}` language translation for Article\##{article.id}."
                  end
                else
                  article_tr = article.translations.build(locale: locale.locale, title: article_hash[:title], body: article_hash[:body])
                  article_tr.save
                  puts "[Zendesk] Create `#{lang['crowdin_language_code']}` language translation for Article\##{article.id}."
                end
              end
            end
          end

        end
      end # @zendesk.locales
    end # @cli_config['categories'].each
  end
end
