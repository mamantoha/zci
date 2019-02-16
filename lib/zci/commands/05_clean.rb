desc 'Clears out the local repository of retrieved files'
command :'clean' do |c|
  c.default_value 'resources'
  c.arg_name 'dir'
  c.flag [:resources_dir]

  c.action do |global_options, options, args|
    puts "Reading state information... Done"
    resources_dir = File.join(File.dirname(global_options[:config]), options[:resources_dir])

    remove_dir(resources_dir)
  end
end
