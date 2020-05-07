module MyLocalPutio
  class DiskManager
    attr_reader :configuration, :logger

    def initialize(configuration)
      @configuration = configuration
      @logger = configuration.logger
    end

    def check_for_available_space_on_destinations!(needed_space)
      return unless configuration.disk_threshold

      [configuration.local_destination, configuration.temp_destination].each do |path|
        free_space = get_folder_free_space(path)
        next unless (free_space - configuration.disk_threshold) <= needed_space
        logger.log "Low disk threshold on path: #{path}! Stopping the script!"
        exit
      end
    end

    def get_folder_free_space(destination)
      space = `df -Pk #{destination}/ | awk 'NR==2 {print $4}'`.to_i
      (space/1024).to_i.round(2)
    end
  end
end
