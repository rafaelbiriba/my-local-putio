# Put.io Fetcher
#
# Put.io download script! The easiest way to have all all your put.io files locally.
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
require "openssl"
require "ostruct"
require "yaml"
require "optparse"
require "my-local-putio/version"
require "my-local-putio/configuration"
require "my-local-putio/logger"
require "my-local-putio/putio_cli"
require "my-local-putio/fetcher"

module MyLocalPutio
end
