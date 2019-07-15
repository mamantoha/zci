class String
  def strip_heredoc
    indent = scan(/^[ \t]*(?=\S)/).min.size || 0
    gsub(/^[ \t]{#{indent}}/, '')
  end
end

module ZCI
  def initialize_zendesk_client(base_url, username, password, verbose)
    ZendeskAPI::Client.new do |config|
      config.url       = base_url
      config.username  = username
      config.password  = password

      if verbose
        require 'logger'
        config.logger = Logger.new(STDOUT)
      end

      config.client_options = {ssl: {verify: false}}
    end
  end
end

# Return +hierarchy+ of directories and files in Crowdin project
#
# +files+ - basically, it's project files details from API method `project_info`
#
def get_remote_files_hierarchy(files, root = '/', hierarchy = { dirs: [], files: [] })
  files.each do |node|
    case node['node_type']
      when 'directory'
        hierarchy[:dirs] << "#{root}#{node['name']}"
        get_remote_files_hierarchy(node['files'], root + node['name'] + '/', hierarchy)
      when 'file'
        hierarchy[:files] << "#{root}#{node['name']}"
    end
  end

  hierarchy
end
