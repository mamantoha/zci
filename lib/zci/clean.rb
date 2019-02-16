module ZCI
  def remove_dir(path)
    if File.exists?(path)
      if File.directory?(path)
        Dir.foreach(path) do |file|
          if (file.to_s != ".") && (file.to_s != "..")
            remove_dir("#{path}/#{file}")
          end
        end
        puts "Del `#{path}`"
        Dir.delete(path)
      else
        puts "Del `#{path}`"
        File.delete(path)
      end
    else
      puts "No such directory - `#{path}`"
    end
  end
end
