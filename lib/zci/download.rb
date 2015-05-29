module ZCI
  def unzip_file_with_translations(zipfile_name, dest_path)
    # overwrite files if they already exist inside of the extracted path
    Zip.on_exists_proc = true

    Zip::File.open(zipfile_name) do |zip_file|
      zip_file.select { |zip_entry| zip_entry.file? }.each do |f|
        # `f' - relative path in archive
        fpath = File.join(dest_path, f.name)
        FileUtils.mkdir_p(File.dirname(fpath))
        puts "Extracting: `#{dest_path}/#{f.name}'"
        zip_file.extract(f, fpath)
      end
    end
  end

  # use export API method before to download the most recent translations
  def export_translations!(crowdin)
    print 'Building ZIP archive with the latest translations '
    export_translations = crowdin.export_translations
    if export_translations['success']
      if export_translations['success']['status'] == 'built'
        puts "- OK"
      elsif export_translations['success']['status'] == 'skipped'
        puts "- Skipped"
        puts "Warning: Export was skipped. Please note that this method can be invoked only once per 30 minutes."
      end
    end
  end

end
