module MyLocalPutio
  class Logger
    attr_reader :configuration

    def initialize(configuration)
        @configuration = configuration
    end

    def verbose?
      configuration.verbose
    end

    def debug?
      configuration.debug
    end

    def debug(msg)
      return unless debug?
      puts "[DEBUG][#{time_now}] #{msg}"
    end

    def log(msg)
      return unless verbose? || debug?
      puts "[LOG][#{time_now}] #{msg}"
    end

    private

    def time_now
      Time.now.strftime("%F %H:%M:%S")
    end
  end
end
