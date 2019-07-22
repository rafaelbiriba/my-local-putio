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

    def fetch_files(id: nil, path: "/")
      logger.log "Getting remote file list for #{path}"
      files = cli.get_files(id)["files"]

      while files.any?
        file = OpenStruct.new(files.pop)
        process_file(file, path)
      end
    end

    def process_file(file, path)
      local_file_path = File.join(path, file.name)
      if file.content_type == "application/x-directory"
        fetch_files(id: file.id, path: local_file_path)
      else
        url = cli.get_download_url(file.id)
        download(url, local_file_path) unless file_exists?(local_file_path, file)
      end
      get_subtitles_for(file, path) if configuration.with_subtitles
      delete_file(local_file_path, file) if configuration.delete_remote
    end

    def file_is_video?(file)
      file.file_type == "VIDEO"
    end

    def get_subtitles_for(file, path)
      return unless file_is_video?(file)
      local_subtitle_path = File.join(path, File.basename(file.name, File.extname(file.name)))
      logger.log "Trying to fetch the preferred subtitle for: #{file.name}"
      subtitles = cli.get_subtitles(file.id)["subtitles"]
      if subtitles.empty?
        logger.log ":( Could not find any preferred subtitle for: #{file.name}"
        return
      end
      process_subtitle(subtitles, file, local_subtitle_path)
    end

    def process_subtitle(subtitles, file, local_subtitle_path)
      subtitles_grouped = subtitles.group_by{|k,v| k["language_code"]}
      subtitles_grouped.each do |language_code, list|
        path = local_subtitle_path + ".#{language_code}.srt"
        logger.log("Starting download of #{list.first["language"]} subtitle for #{file.name}")
        download(list.first["url"], path)
      end
    end

    def delete_file(local_file_path, file)
      logger.log "Deleting remote file: #{local_file_path}"
      cli.delete_file(file.id)
    end

    def file_exists?(local_file_path, file)
      file_exists = File.exists?(local_file_path) && File.size(local_file_path) == file.size
      logger.log "File already downloaded #{local_file_path}" if file_exists
      file_exists
    end

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

    def download(url, path)
      logger.debug "Download file from #{url}"
      command = download_command(url, path)
      logger.log "Downloading: #{path}"
      fetch_result = system(*command)
      raise "Unable to download #{path}" unless fetch_result
    end
  end
end
