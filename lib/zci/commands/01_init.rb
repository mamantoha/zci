desc 'Create new ZCI-based project'
arg 'project_name'
arg_name 'project_name'
skips_pre
command :'init:project' do |c|
  c.desc 'Root dir of project'
  c.long_desc <<-EOS.strip_heredoc
    This is the directory where the project's directory will be made, so if you
    specify a project name `foo` and the root dir of `.`, the directory
    `./foo` will be created
  EOS
  c.flag :r, :root, :default_value => '.'

  c.switch :force, :desc => 'Overwrite/ignore existing files and directories'

  c.action do |global_options, options, args|
    if args.length < 1
      raise 'You must specify the name of your project'
    end

    root_dir = options[:root]
    force = options[:force]
    project_name = args.first

    create_scaffold(root_dir, project_name, force)
  end
end

