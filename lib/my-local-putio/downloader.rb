module MyLocalPutio
  class Downloader
    attr_reader :configuration, :logger

    def initialize(configuration)
      @configuration = configuration
      @logger = configuration.logger
    end

    def download(url, path)
      logger.debug "Download file from #{url}"
      logger.log "Downloading: #{path}"
      command = download_command(url, path)
      fetch_result = system(*command)
      raise "Unable to download #{path}" unless fetch_result
      logger.log "Finishing the download..."
      move_downloaded_file!(path)
    end

    private

    def move_downloaded_file!(path)
      temp_file = File.join(configuration.temp_destination, path)
      local_file = File.join(configuration.local_destination, path)

      # Create destination folder
      FileUtils.mkdir_p(File.dirname(local_file))

      logger.debug "Moving file from #{temp_file} to #{local_file}"
      FileUtils.mv(temp_file, local_file)

      # Delete temporary file
      FileUtils.rm_rf(temp_file)

      # Delete temporary folder if empty
      Dir.rmdir(File.dirname(temp_file)) rescue Errno::ENOTEMPTY
    end

    def download_command(url, path)
      temp_destination = File.join(configuration.temp_destination, path)

      command = [
        "curl", "--create-dirs", "--progress-bar", "-L", "--retry", "5", "-S", "-C", "-", "-o", temp_destination, url.to_s
      ]

      command.push("--silent") if logger.silent?

      if configuration.socks_enabled?
        command.push("--socks5-hostname", "#{configuration.socks_host}:#{configuration.socks_port}")
      end

      return command
    end
  end
end
