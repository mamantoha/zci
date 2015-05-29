class String
  def strip_heredoc
    indent = scan(/^[ \t]*(?=\S)/).min.size || 0
    gsub(/^[ \t]{#{indent}}/, '')
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

  return hierarchy
end
