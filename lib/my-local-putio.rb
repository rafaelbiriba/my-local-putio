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

require "net/http"
require "openssl"
require "ostruct"
require "yaml"
require "optparse"
require "putio_fetcher/version"
require "putio_fetcher/configuration"
require "putio_fetcher/logger"
require "putio_fetcher/putio_cli"
require "putio_fetcher/fetcher"

module MyLocalPutio
end
