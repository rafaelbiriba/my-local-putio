module MyLocalPutio
  class Fetcher
    attr_reader :configuration, :cli, :logger

    def initialize(configuration)
      @configuration = configuration
      @logger = configuration.logger
      @cli = PutioCli.new(@configuration)
    end

    def run!
      fetch_files
    end

    protected

    def fetch_files(id: nil, path: configuration.local_destination)
      FileUtils.mkdir_p(path)
      logger.log "Getting files for #{path}"
      files = cli.get_files(id)["files"]

      while files.any?
        file = OpenStruct.new files.pop
        process_file(file, path)
      end
    end

    def process_file(file, path)
      file_path = File.join(path, file.name)
      if file.content_type == "application/x-directory"
        fetch_files(id: file.id, path: file_path)
      else
        return if check_file_exists?(file_path, file)
        url = cli.get_download_url file.id
        fetch(url, file_path)
      end
    end

    def check_file_exists?(file_path, file)
      file_exists = File.exists?(file_path) && File.size(file_path) == file.size
      logger.log "File already downloaded #{file_path}" if file_exists
      file_exists
    end

    def fetch_command(url, path)
      command = [
        "curl", "--progress-bar", "-L", "--retry", "5", "-S", "-C", "-", "-o", path, url.to_s
      ]

      command.push("--silent") if logger.silent?

      if configuration.socks_enabled?
        command.push("--socks5-hostname", "#{configuration.socks_host}:#{configuration.socks_port}")
      end

      return command
    end

    def fetch(url, path)
      command = fetch_command(url, path)
      logger.log "Downloading: #{path}"
      fetch_result = system(*command)
      raise "Unable to download #{path}" unless fetch_result
    end
  end
end
