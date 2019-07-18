module MyLocalPutio
  class Logger
    attr_reader :configuration

    def initialize(configuration)
        @configuration = configuration
    end

    def silent?
      configuration.silent
    end

    def debug?
      configuration.debug
    end

    def debug(msg)
      return unless debug?
      print_msg "[DEBUG][#{time_now}] #{msg}"
    end

    def log(msg)
      print_msg "[LOG][#{time_now}] #{msg}"
    end

    private

    def print_msg(msg)
      return if silent?
      puts msg
    end

    def time_now
      Time.now.strftime("%F %H:%M:%S")
    end
  end
end
