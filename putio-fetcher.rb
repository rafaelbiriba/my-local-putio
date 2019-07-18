# Put.io Fetcher
#
# Put.io download script! The easiest way to have all all your put.io files locally.
#
# Created by: Rafael Biriba - biribarj@gmail.com
# More info: https://github.com/rafaelbiriba/putio-fetcher
#
# Copyright disclaimer:
# Put.io fetcher uses the official Put.io API v2. Use this tool for legal purposes
# only. You are the only one responsible for what you are downloading from
# your put.io account, ensuring that your download does not infringe any legal 
# or copyright constraints. Put.io Fetcher or the script author will not take
# responsibility for any of your downloading acts.

require "cgi"
require "fileutils"
require "net/http"
require "openssl"
require "ostruct"
require "pp"
require "uri"
require "yaml"
require "optparse"

unless open(__FILE__).flock(File::LOCK_EX | File::LOCK_NB)
  puts "Script already running..."
  exit
end

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

# https://api.put.io/v2/docs/
class PutIO
  ROOT = "https://api.put.io/v2/"
  attr_reader :configuration, :endpoint, :http, :logger

  def initialize(configuration, endpoint=ROOT, logger)
    @configuration, @endpoint, @logger = configuration, URI(endpoint), logger
    @http = Net::HTTP.new(@endpoint.host, @endpoint.port)
    @http.use_ssl = true
    # Not good ...
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  def get_files(parent_id=nil)
    args = parent_id ? {parent_id: parent_id} : {}
    get("files/list", args)
  end

  def get_download_url(id)
    # Follow redirect plz
    url = to_url("files/#{id}/download")
    url.query = URI.encode_www_form to_args()
    url
  end

  protected

  def log(msg)
    return unless configuration.verbose
    puts msg
  end

  def get(path, args={})
    url = to_url(path)
    url.query = URI.encode_www_form to_args(args)
    req = Net::HTTP::Get.new(url.request_uri)
    logger.debug "GET #{url}"
    as_json http.request(req)
  end

  def post(path, args={})
    url = to_url(path)
    args = to_args(args)
    logger.debug "POST #{url} -- #{args.inspect}"
    req = Net::HTTP::Post.new("/users")
    req.set_form_data(args)
    as_json http.request(req)
  end

  def to_url(path)
    url = endpoint.dup
    url.path += path
    url
  end

  def to_args(args={})
    ret = {}
    args.each_pair do |k,v|
      ret[k.to_s] = v
    end
    args["oauth_token"] = configuration.token
    args
  end

  def as_json(res)
    raise "woot? #{res.inspect}" unless res.is_a?(Net::HTTPSuccess)
    YAML.load res.body
  end
end

class Fetcher
  attr_reader :configuration, :cli, :logger

  def initialize(configuration, cli, logger)
    @configuration, @cli, @logger = configuration, cli, logger
  end

  def run!
    fetch_files
  end

  protected

  def fetch_files(id: nil, path: configuration.destination)
    FileUtils.mkdir_p(path)
    logger.log "Getting files for #{path}"
    files = cli.get_files(id)["files"]

    while files.any?
      file = OpenStruct.new files.pop
      if file.content_type == "application/x-directory"
        fetch_files(id: file.id, path: File.join(path, file.name))
      else
	      file_path = File.join(path, file.name)
        if File.exists?(file_path) && File.size(file_path) == file.size
          logger.log "File already downloaded #{file_path}"
        else
	        url = cli.get_download_url file.id
          logger.log "Downloading: #{file_path}"
          if ! fetch(url, file_path)
	           raise "Unable to download #{file_path}"
          end
        end
      end
    end
  end

  def fetch(url, path)
    command = [
      "curl", "--progress-bar", "-L", "--retry", "5", "-S", "-C", "-", "-o", path, url.to_s
    ]
    command.push("--silent") unless logger.verbose?
    system(*command)
  end
end

configuration = Configuration.new
logger = Logger.new(configuration)
putio_cli = PutIO.new(configuration, logger)
Fetcher.new(configuration, putio_cli, logger).run!
