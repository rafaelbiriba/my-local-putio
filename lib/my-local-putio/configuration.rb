module MyLocalPutio
  class Configuration
    attr_reader :token, :destination, :verbose, :debug
    def initialize
      read_args_from_envs!
      parse_args!
      validate_args!
    end

    private
    def parse_args!
      OptionParser.new do |opt|
        opt.on("-t", "--token TOKEN", "Put.io access token [REQUIRED]") { |v| @token = v }
        opt.on("-d", "--destination DESTINATION", "Destination path [REQUIRED]") { |v| @destination = v }
        opt.on("-v", "--verbose", "Show messages and progress bar") { |v| @verbose = true }
        opt.on("--debug", "Debug mode [Developer mode]") { |v| @debug = true }
      end.parse!
    end

    def validate_args!
      unless @token
        raise OptionParser::MissingArgument.new("--token")
      end

      unless @destination
        raise OptionParser::MissingArgument.new("--destination")
      end
    end

    def read_args_from_envs!
      @token ||= ENV["PUTIO_TOKEN"]
    end
  end
end
