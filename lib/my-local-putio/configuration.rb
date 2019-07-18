module MyLocalPutio
  class Configuration
    attr_reader :token, :local_destination, :silent, :debug
    def initialize
      read_args_from_envs!
      parse_args!
      validate_args!
    end

    private
    def parse_args!
      OptionParser.new do |opt|
        opt.on("-t", "--token TOKEN", "Put.io access token [REQUIRED]") { |v| @token = v }
        opt.on("-l", "--local-destination PATH", "Local destination path [REQUIRED]") { |v| @local_destination = v }
        opt.on("-s", "--silent", "Hide all messages and progress bar") { |v| @silent = true }
        opt.on("-d", "--debug", "Debug mode [Developer mode]") { |v| @debug = true }
      end.parse!
    end

    def validate_args!
      unless @token
        raise OptionParser::MissingArgument.new("--token")
      end

      unless @local_destination
        raise OptionParser::MissingArgument.new("--local-destination")
      end
    end

    def read_args_from_envs!
      @token ||= ENV["PUTIO_TOKEN"]
    end
  end
end
