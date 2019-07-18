Put.io Fetcher
===========

[Put.io](http://put.io) download script! The easiest way to have all all your put.io files locally.

For now the script only supports download the content from your account and keep it locally.

### Features

- Check and skip already downloaded files
- Resume broken/stopped downloads, so you don't have to start from the begin of your huge file.
- Simple and easy to run

#### Planned features:
- Option to delete the file on put.io after sync
- Option to download the subtitle if available in put.io list

#### Future or ideas:
- Add a magnet/torrent to the put.io account based on local files or references.

## Copyright Disclaimer

Put.io fetcher uses the official Put.io API v2. Use this tool for legal purposes only. You are the only one responsible for what you are downloading from your put.io account, ensuring that your download does not infringe any legal or copyright constraints.
Put.io Fetcher or the script author will not take responsibility for any of your downloading acts.

## Install

* Install ruby 2.6.0+
* Create an "application" here and note down the TOKEN: https://put.io/v2/oauth2/applications
* Download the script code from githug or via wget command below:
      wget https://raw.githubusercontent.com/rafaelbiriba/putio-fetcher/master/putio-fetcher.rb

## Usage

    ruby putio-fetcher.rb -h

    Usage: putio-fetcher [options]
    -t, --token TOKEN                Put.io access token [REQUIRED]
    -d, --destination DESTINATION    Destination path [REQUIRED]
    -v, --verbose                    Show messages and progress bar
        --debug                      Debug mode [Developer mode]

#### Required attributes:
* **-t** or **--token**: Your Put.io Token. This attribute becames optional if you set `PUTIO_TOKEN` env variable with your token (Can be inline or into your bash profile). Check examples below.
* **-d** or **--destination**: Local destination folder

Examples:

    ruby putio-fetcher.rb -t 123 -d Downloads
    ruby putio-fetcher.rb -d Downloads --token 123

With Token variable (inline or exporting):

      PUTIO_TOKEN=123 ruby putio-fetcher.rb -d Downloads

      export PUTIO_TOKEN=123
      ruby putio-fetcher.rb -d Downloads

#### Others attributes:
* **-h**: Print the help usage message
* **-v** or **--verbose**: Show useful information about your downloads
* **--debug**: Developer mode: Prints everything (also verbose messages) and expose URLs with tokens for debug purposes.

Examples:

    ruby putio-fetcher.rb -h
    ruby putio-fetcher.rb -t 123 -d Downloads --verbose
    ruby putio-fetcher.rb -t 123 -d Downloads -v
    ruby putio-fetcher.rb --destination Downloads -t 123 --debug

Verbose output example:

    [LOG][2019-07-18 11:11:30] Getting files for Downloads
    [LOG][2019-07-18 11:11:31] Getting files for Downloads/ubuntu-18.04.2-desktop-amd64.iso
    [LOG][2019-07-18 11:11:31] Downloading: Downloads/ubuntu-18.04.2-desktop-amd64.iso
    ######################################################################## 100.0%

#### Troubleshooting

##### 401 UNAUTHORIZED
If you token is invalid, the script will stop with `401` error message.
