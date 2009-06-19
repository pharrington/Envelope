module Attachable
  def upload(file)
    dest = unique(File.join(attachment_dir, file.original_filename))
    FileUtils.mv(file.local_path, dest)
    File.chmod(0644, dest)
    File.basename(dest)
  end

  def attachment_dir
    create_directory!
    path = read_attribute(:attachment_dir)
    Rails.root.join('attachments', path, user)
  end

  private
    def user
      email
    end

    def unique(filename)
      count = 0
      unique_name = lambda { count == 0 ? filename : filename + "_#{count}" }
      count += 1 until !File.exists?(unique_name.call)
      unique_name.call
    end

    def create_directory!
      begin
        path = read_attribute(:attachment_dir) || create_prefix
        FileUtils.mkdir_p(Pathname.new("attachments").join(path, user, 'static'))
        write_attribute(:attachment_dir, path)
        save
        true
      rescue Errno::EEXIST
        false
      rescue
        raise
      end
    end

    def create_prefix
      File.join((1..2).collect { format("%02d", rand(99)) })
    end
end
