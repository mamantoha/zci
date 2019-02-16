desc 'Zendesk and Crowdin info'
command :'project:info' do |c|
  c.action do |global_options, options, args|
    puts "ruby #{RUBY_VERSION}"
    puts "zci #{ZCI::VERSION}"
    puts "zendesk_help_center_api #{ZendeskAPI::HelpCenter::VERSION}"
    puts
    # Crowdin
    begin
      crowdin_info = @crowdin.project_info
      puts "Crowdin: authentication successful."
      puts "Crowdin: available locales:"
      crowdin_info["languages"].each do |lang|
        puts "  - #{lang['code']}"
      end
    rescue => e
      puts "Crowdin: API key is incorect"
    end
    puts

    # Zendesk
    if @zendesk.current_user.id
      puts "Zendesk: authentication successful."
      categories = @zendesk.hc_categories

      puts "Zendesk: available categories:"
      categories.each do |category|
        puts "  - #{category.id}: #{category.name}"
      end

      locales = @zendesk.locales

      puts "Zendesk: available locales:"
      locales.each do |locale|
        puts "  - #{locale.locale}"
      end
    else
      puts "Zendesk: login and/or password is incorect"
    end
  end
end
