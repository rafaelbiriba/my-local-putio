# My Local Put.io
#
# The easiest script to synchronise all your put.io files locally.
#
# Created by: Rafael Biriba - biribarj@gmail.com
# More info: https://github.com/rafaelbiriba/my-local-putio
#
# Copyright disclaimer:
# My Local Put.io uses the official Put.io API v2. Use this tool for legal purposes
# only. You are the only one responsible for what you are downloading from
# your put.io account, ensuring that your download does not infringe any legal
# or copyright constraints. My Local Put.io or the script author will not take
# responsibility for any of your downloading acts.

require "net/http"
require "socksify/http"
require "socket"
require "openssl"
require "ostruct"
require "yaml"
require "optparse"
require "my-local-putio/version"
require "my-local-putio/configuration"
require "my-local-putio/logger"
require "my-local-putio/putio_cli"
require "my-local-putio/fetcher"
require "my-local-putio/downloader"
require "my-local-putio/subtitles_manager"

module MyLocalPutio
  def self.print_introduction_msg(configuration)
    return if configuration.silent
    puts "Starting My Local Put.io - version #{VERSION}"
    puts "https://github.com/rafaelbiriba/my-local-putio"
    puts "============================================="
    puts "Full path of the local destination: #{File.realdirpath(configuration.local_destination)}"
    puts ">>> Delete remote files enabled!" if configuration.delete_remote
    puts ">>> With subtitles enabled!" if configuration.with_subtitles
    puts ">>> SOCKS5 enabled with #{configuration.socks_host}:#{configuration.socks_port}" if configuration.socks_enabled?
    puts ">>> DEBUG enabled! Hello Mr(s) developer :)" if configuration.debug
    puts "============================================="
    sleep 2 # In case the configurations are not correct, 2 seconds to kill the command line before run
  end
end
