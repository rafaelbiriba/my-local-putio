My Local Put.io [![Gem Version](https://badge.fury.io/rb/my-local-putio.svg)](http://badge.fury.io/rb/my-local-putio) [![Code Climate](https://codeclimate.com/github/rafaelbiriba/my-local-putio/badges/gpa.svg)](https://codeclimate.com/github/rafaelbiriba/my-local-putio)
===========

The easiest script to synchronize all your [Put.io](http://put.io) files locally.

After the download, you can enable the option to remove the files from Put.io and also download your preferred subtitles if available in Put.io.

### Features

- Check and skip already downloaded files.
- Resume broken/stopped downloads, so you don't have to start from the begin of your huge file.
- Supports SOCKS5 proxy for an even more secure and anonymous transfer, with kill switch, so the application will stop if the proxy became unavailable. No leak connections.
- Option to delete the file from put.io after the download
- Option to download your preferred subtitles from Put.io.
- Simple and easy to run
- For free and forever free :)

## Copyright Disclaimer

`My Local Put.io` uses the official Put.io API v2. Use this tool for legal purposes only. You are the only one responsible for what you are downloading from your put.io account, ensuring that your download does not infringe any legal or copyright constraints.
`My Local Put.io` or the script author will not take responsibility for any of your downloading acts.

## Install

* Install ruby 2.6.0+
* Generate a token for your put.io account: https://app.put.io/authenticate?client_id=1&response_type=oob
* Install the latest version of `my-local-putio` gem:

      gem install my-local-putio

To update your installed version:

      gem update my-local-putio

## Usage

    my-local-putio -h

    Usage: my-local-putio [options]
      -t, --token TOKEN                Put.io access token [REQUIRED]
      -l, --local-destination FULLPATH Local destination path [REQUIRED]
      -d, --delete-remote              Delete remote file/folder after the download
      -s, --with-subtitles             Fetch subtitles from Put.io api
      -v, --version                    Print my-local-putio version
          --temp-destination FULLPATH  Temporary destination for the incomplete downloads (Default: 'local_destination'/incomplete_downloads)
          --silent                     Hide all messages and progress bar
          --debug                      Debug mode [Developer mode]
          --socks5-proxy hostname:port SOCKS5 hostname and port for proxy. Format: 127.0.0.1:1234
          --disk-threshold size        Stops the downloads when the disk space threshold is reached. (Size in MB, e.g: 2000 for 2GB)

#### Required attributes:
* **-t** or **--token**: Your Put.io Token. This attribute becames optional if you set `PUTIO_TOKEN` env variable with your token (Can be inline or into your bash profile). Check examples below.
* **-l** or **--local-destination**: Local destination folder

Examples:

    my-local-putio -t 123 -l Downloads
    my-local-putio -l Downloads --token 123
    my-local-putio -l Downloads -t token123 -d -s --socks5-proxy 127.0.0.1:1234
    my-local-putio -d -s --disk-threshold 1000

With Token variable (inline or exporting):

      PUTIO_TOKEN=123 my-local-putio -l Downloads

      export PUTIO_TOKEN=123
      my-local-putio --local-destination Downloads/

#### Others attributes:
* **-d** or **--delete-remote**: Delete the remote file/folder from put.io after downloading
* **-s** or **--with-subtitles**: Download subtitles from Put.io API if available. (Remember to set your preferred subtitle language on Put.io Settings website, otherwise no subtitle will be available for download.)
* **-h**: Print the help usage message
* **-v** or **--version**: Print the version of the application
* **--temp-destination**: Overwrite the default path (incomplete_downloads folder) of the temporary download files. After the download the complete file is moved to the selected local destination.
* **--silent**: Hide all messages and progress bar. Recommended for Cronjob tasks.
* **--debug**: Developer mode: Prints everything and expose URLs with tokens for debug purposes.
* **--socks5-proxy**: Enable the SOCKS5 proxy. If enabled, all the connections for PUT.IO API and the downloads will be performed using this proxy. If the socks connection became unavailable, the application will raise an error and will stop.
* **--disk-threshold**: Set a disk threshold **(in MB)** to prevent the script to fill up the entire disk. The threshold value is in MB **(e.g 1000 for 1GB)**. The script will test both download folder and temporary folder to detect if there is enough space before download each file. If the free space is less than (file size + disk threshold) the script will stop. (Example: If the folder have 10GB available, and the threshold is set to 2GB (2000), the script will stop before start downloading a file with 9GB size)

Examples:

    my-local-putio -h
    my-local-putio -t 123 -l Downloads --silent -d -s
    my-local-putio -t 123 -l Downloads --silent
    my-local-putio -l Downloads -t 123 --temp-destination /tmp --with-subtitles
    my-local-putio --local-destination Downloads -t 123 --debug --with-subtitles
    my-local-putio --local-destination Downloads -t 123 --socks5-proxy 127.0.0.1:3333
    my-local-putio -d -s --disk-threshold 1000

Verbose output example:

    my-local-putio -t 123 -l Downloads -d -s --socks5-proxy 127.0.0.1:3333 --temp-destination /tmp --disk-threshold 2000

    Starting My Local Put.io - version 4.3.0
    https://github.com/rafaelbiriba/my-local-putio
    =============================================
    Full path of the local destination: /Users/user/Downloads (Free space: 19667 MB)
    Full path of the temporary destination: /tmp (Free space: 8543 MB)
    >>> Delete remote files enabled!
    >>> With subtitles enabled!
    >>> SOCKS5 enabled with 127.0.0.1:3333
    >>> With disk threshold of 2000 MB!
    =============================================
    [LOG][2019-07-18 11:11:30] Getting file list for /
    [LOG][2019-07-18 11:11:31] Getting file list for /ubuntu
    [LOG][2019-07-18 11:11:31] Downloading: /ubuntu/ubuntu-18.04.2-desktop-amd64.iso
    ######################################################################## 100.0%
    [LOG][2019-07-18 11:11:33] Deleting remote file: /ubuntu/ubuntu-18.04.2-desktop-amd64.iso
    [LOG][2019-07-18 11:11:34] Finishing the download...

#### Troubleshooting

##### 401 UNAUTHORIZED
If you token is invalid, the script will stop with `401` error message.


## Contributing

First of all, **thank you** for wanting to help!

1. [Fork it](https://help.github.com/articles/fork-a-repo).
2. Create a feature branch - `git checkout -b more_magic`
3. Add tests and make your changes
4. Check if tests are ok - `rake spec`
5. Commit changes - `git commit -am "Added more magic"`
6. Push to Github - `git push origin more_magic`
7. Send a [pull request](https://help.github.com/articles/using-pull-requests)! :heart:
