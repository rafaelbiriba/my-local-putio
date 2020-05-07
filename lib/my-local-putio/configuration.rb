module MyLocalPutio
  class Configuration
    attr_reader :token, :local_destination, :temp_destination,
                :silent, :debug, :socks_host, :socks_port, :delete_remote, :with_subtitles,
                :disk_threshold

    def initialize
      read_args_from_envs!
      parse_args!
      set_defaults!
      validate_args!
    end

    def disk_manager
      @disk_manager ||= DiskManager.new(self)
    end

    def socks_enabled?
      @socks_host || @socks_port
    end

    def logger
      @logger ||= Logger.new(self)
    end

    private
    def parse_args!
      OptionParser.new do |opt|
        opt.on("-t", "--token TOKEN", "Put.io access token [REQUIRED]") { |v| @token = v }
        opt.on("-l", "--local-destination FULLPATH", "Local destination path [REQUIRED]") { |v| @local_destination = v }
        opt.on("-d", "--delete-remote", "Delete remote file/folder after the download") { |v| @delete_remote = true }
        opt.on("-s", "--with-subtitles", "Fetch subtitles from Put.io api") { |v| @with_subtitles = true }
        opt.on("-v", "--version", "Print my-local-putio version") do
          puts MyLocalPutio::VERSION
          exit
        end

        opt.on("--temp-destination FULLPATH", "Temporary destination for the incomplete downloads (Default: 'local_destination'/incomplete_downloads)") { |v| @temp_destination = v }
        opt.on("--silent", "Hide all messages and progress bar") { |v| @silent = true }
        opt.on("--debug", "Debug mode [Developer mode]") { |v| @debug = true }
        opt.on("--socks5-proxy hostname:port", "SOCKS5 hostname and port for proxy. Format: 127.0.0.1:1234") do |v|
          @socks_host, @socks_port = v.to_s.split(":")
        end
        opt.on("--disk-threshold size", "Stops the downloads when the disk space threshold is reached. (Size in MB, e.g: 2000 for 2GB)") do |v|
          @disk_threshold = v.to_i
        end
      end.parse!
    end

    def set_defaults!
      @temp_destination ||= File.join(@local_destination, "incomplete_downloads")
    end

    def validate_args!
      unless @token
        puts "Missing token"
        exit
      end

      unless @local_destination
        puts "Missing local destination"
        exit
      end

      folder_checks!(@local_destination)
      folder_checks!(@temp_destination)

      if socks_enabled? && !port_is_open?(@socks_host, @socks_port)
        puts "Cannot connect to socks using '#{@socks_host}:#{@socks_port}'"
        exit
      end
    end

    def folder_checks!(folder)
      return if File.exists?(folder) && File.writable?(folder)
      FileUtils.mkdir_p(folder)
    rescue Errno::EACCES
      puts "Cannot write on the local destination path '#{folder}'"
      exit
    end

    def read_args_from_envs!
      @token ||= ENV["PUTIO_TOKEN"]
    end

    def port_is_open?(host, port)
      Socket.tcp(host, port, connect_timeout: 5) { true } rescue false
    end
  end
end
