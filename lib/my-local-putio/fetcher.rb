module MyLocalPutio
  class Fetcher
    attr_reader :configuration, :cli, :disk_manager, :logger, :downloader

    def initialize(configuration)
      @configuration = configuration
      @logger = configuration.logger
      @disk_manager = configuration.disk_manager
      @cli = PutioCli.new(@configuration)
      @downloader = Downloader.new(@configuration)
    end

    def run!
      fetch_files
    end

    private

    def fetch_files(id: nil, path: "/")
      logger.log "Getting remote file list for folder #{path}"
      files = cli.get_files(id)["files"]

      while files.any?
        file = OpenStruct.new(files.pop)
        process_file(file, path)
      end
    end

    def process_file(file, path)
      file_path = File.join(path, file.name)
      if file.content_type == "application/x-directory"
        fetch_files(id: file.id, path: file_path)
      else
        url = cli.get_download_url(file.id)["url"]
        disk_manager.check_for_available_space_on_destinations!(file.size/1024/1024)
        Downloader.new(@configuration).download(url, file_path) unless file_exists?(file_path, file)
        SubtitlesManager.new(configuration).fetch(file, path)
      end
      delete_file(file_path, file)
    end

    def delete_file(file_path, file)
      return unless configuration.delete_remote
      logger.log "Deleting remote #{file.file_type.downcase}: #{file_path}"
      cli.delete_file(file.id)
    end

    def file_exists?(file_path, file)
      local_full_path = File.join(configuration.local_destination, file_path)
      file_exists = File.exists?(local_full_path) && File.size(local_full_path)/1024 == file.size/1024
      logger.log "File already downloaded #{file_path}" if file_exists
      file_exists
    end
  end
end
