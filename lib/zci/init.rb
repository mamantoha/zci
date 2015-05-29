require 'fileutils'

module ZCI
  def create_scaffold(root_dir, project_name, force)
    dir = File.join(root_dir, project_name)

    if mkdir(dir, force)
      mk_config(root_dir, project_name)
    end
  end

  def mkdir(dir, force)
    exists = false
    if !force
      if File.exist? dir
        raise "#{dir} exists; use --force to override"
        exists = true
      end
    end

    if !exists
      puts "Creating dir #{dir}..."
      FileUtils.mkdir_p dir
    else
      puts "Exiting..."
      false
    end

    true
  end

  def mk_config(root_dir, project_name)
    config = <<-EOS.strip_heredoc
    ---
    # Crowdin API credentials
    crowdin_project_id: '<%your-crowdin-project-id%>'
    crowdin_api_key: '<%your-crowdin-api-key%>'
    crowdin_base_url: 'https://api.crowdin.com'

    # Zendesk API credentials
    zendesk_base_url: 'https://<%subdomain%>.zendesk.com'
    zendesk_username: '<%your-zendesk-username%>'
    zendesk_password: '<%your-zendesk-password%>'

    # Zendesk catogories
    categories:
    - zendesk_category: '<%zendesk-category-id%>'
      translations:
        -
          crowdin_language_code: '<%crowdin-two-letters-code%>'
          zendesk_locale: '<%zendesk-locale%>'
        -
          crowdin_language_code: '<%crowdin-two-letters-code%>'
          zendesk_locale: '<%zendesk-locale%>'
    - zendesk_category: '<%zendesk-category-id%>'
      translations:
        -
          crowdin_language_code: '<%crowdin-two-letters-code%>'
          zendesk_locale: '<%zendesk-locale%>'
        -
          crowdin_language_code: '<%crowdin-two-letters-code%>'
          zendesk_locale: '<%zendesk-locale%>'
    EOS

    File.open("#{root_dir}/#{project_name}/zci.yml", 'w') do |file|
      file << config
    end

    puts "Created #{root_dir}/#{project_name}/zci.yml"
  end
end
