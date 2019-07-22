module MyLocalPutio
  class SubtitlesManager
    attr_reader :configuration, :logger, :cli, :downloader

    def initialize(configuration)
      @configuration = configuration
      @logger = configuration.logger
      @cli = PutioCli.new(@configuration)
      @downloader = Downloader.new(@configuration)
    end

    def fetch(file, path)
      return unless configuration.with_subtitles
      return unless file_is_video?(file)

      local_subtitle_path = File.join(path, filename(file))
      logger.log "Trying to fetch the preferred subtitle for: #{file.name}"
      subtitles = cli.get_subtitles(file.id)["subtitles"]
      if subtitles.empty?
        logger.log ":( Could not find any preferred subtitle for: #{file.name}"
        return
      end

      process_subtitle(subtitles, local_subtitle_path)
    end

    private
    def filename(file)
      File.basename(file.name, File.extname(file.name))
    end

    def file_is_video?(file)
      file.file_type == "VIDEO"
    end

    def process_subtitle(subtitles, local_subtitle_path)
      subtitles_grouped = subtitles.group_by{|k,v| k["language_code"]}
      subtitles_grouped.each do |language_code, list|
        path = local_subtitle_path + ".#{language_code}.srt"
        logger.log("#{list.first["language"]} subtitle found!")
        downloader.download(list.first["url"], path)
      end
    end
  end
end
