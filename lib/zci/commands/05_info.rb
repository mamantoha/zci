require 'byebug'

desc 'Zendesk and Crowdin info'
command :'project:info' do |c|
  c.action do |global_options, options, args|
    # Crowdin
    begin
      crowdin_info = @crowdin.project_info
      puts "Crowdin: success!"
      puts "Crowdin: available locales:"
      crowdin_info["languages"].each do |lang|
        puts "#{lang['code']}"
      end
    rescue => e
      puts "Crowdin: API key is incorect"
    end
    puts

    # Zendesk
    if @zendesk.current_user.id
      puts "Zendesk: success!"
      categories = @zendesk.hc_categories

      puts "Zendesk: available categories"
      categories.each do |category|
        puts "#{category.id}: #{category.name}"
      end
      puts

      locales = @zendesk.locales

      puts "Zendesk: available locales:"
      locales.each do |locale|
        puts "#{locale.locale}"
      end
    else
      puts "Zendesk: login and/or password is incorect"
    end
  end
end
