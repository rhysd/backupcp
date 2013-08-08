require "backupcp/version"

module Backupcp extend self
  def replace_files_with_backup files,destdir
    raise "destdir is not a directory" unless File.directory? destdir

    files.select{|f| File.exists? f}.each do |f|
      base = File.basename f
      target = File.join [destdir, base]
      FileUtils.move target, "#{target}.original" if File.exists? target
      FileUtils.copy f, target
    end
  end

  def replace_dir_with_backup fromdir,destdir
    raise "fromdir is not a directory" unless File.directory? fromdir
    raise "destdir is not a directory" unless File.directory? destdir

    replace_files_with_backup Dir.glob(File.join [fromdir, '*']).to_a, destdir
  end

  def replace_with_backup from, dest
    case from
    when Array then replace_files_with_backup from, dest
    when String then replace_dir_with_backup from, dest
    else raise "invalid argument type"
    end
  end

  def help
    puts <<-EOS.gsub(/^\s+/, "")
      backupcp file1 [, file2, ...] destdir
      backupcp fromdir destdir
    EOS
    exit
  end
end
