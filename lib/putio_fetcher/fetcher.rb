module PutioFetcher
  class Fetcher
    attr_reader :configuration, :cli, :logger

    def initialize(configuration, cli, logger)
      @configuration, @cli, @logger = configuration, cli, logger
    end

    def run!
      fetch_files
    end

    protected

    def fetch_files(id: nil, path: configuration.destination)
      FileUtils.mkdir_p(path)
      logger.log "Getting files for #{path}"
      files = cli.get_files(id)["files"]

      while files.any?
        file = OpenStruct.new files.pop
        if file.content_type == "application/x-directory"
          fetch_files(id: file.id, path: File.join(path, file.name))
        else
  	      file_path = File.join(path, file.name)
          if File.exists?(file_path) && File.size(file_path) == file.size
            logger.log "File already downloaded #{file_path}"
          else
  	        url = cli.get_download_url file.id
            logger.log "Downloading: #{file_path}"
            if ! fetch(url, file_path)
  	           raise "Unable to download #{file_path}"
            end
          end
        end
      end
    end

    def fetch(url, path)
      command = [
        "curl", "--progress-bar", "-L", "--retry", "5", "-S", "-C", "-", "-o", path, url.to_s
      ]
      command.push("--silent") unless logger.verbose?
      system(*command)
    end
  end
end
