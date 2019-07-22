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
    end

    private

    def download_command(url, path)
      destination = File.join(configuration.local_destination, path)

      command = [
        "curl", "--create-dirs", "--progress-bar", "-L", "--retry", "5", "-S", "-C", "-", "-o", destination, url.to_s
      ]

      command.push("--silent") if logger.silent?

      if configuration.socks_enabled?
        command.push("--socks5-hostname", "#{configuration.socks_host}:#{configuration.socks_port}")
      end

      return command
    end
  end
end
