My Local Put.io
===========

The easiest script to synchronize all your [Put.io](http://put.io) files locally.

For now the script only supports download the content from your account and keep it locally.

### Features

- Check and skip already downloaded files
- Resume broken/stopped downloads, so you don't have to start from the begin of your huge file.
- Simple and easy to run

#### Planned features:

- Option to delete the file on put.io after sync
- Option to download the subtitle if available in put.io list

#### Future or ideas: (Feel free to contribute to the list)

- Add a magnet/torrent to the put.io account based on local files or references.

## Copyright Disclaimer

`My Local Put.io` uses the official Put.io API v2. Use this tool for legal purposes only. You are the only one responsible for what you are downloading from your put.io account, ensuring that your download does not infringe any legal or copyright constraints.
`My Local Put.io` or the script author will not take responsibility for any of your downloading acts.

## Install

* Install ruby 2.6.0+
* Generate a token for your put.io account: https://app.put.io/authenticate?client_id=1&response_type=oob
* Install the `my-local-putio` gem:

      gem install my-local-putio

## Usage

    my-local-putio -h

    Usage: my-local-putio [options]
        -t, --token TOKEN                Put.io access token [REQUIRED]
        -l, --local-destination PATH     Local destination path [REQUIRED]
        -s, --silent                     Hide all messages and progress bar
        -d, --debug                      Debug mode [Developer mode]

#### Required attributes:
* **-t** or **--token**: Your Put.io Token. This attribute becames optional if you set `PUTIO_TOKEN` env variable with your token (Can be inline or into your bash profile). Check examples below.
* **-l** or **--local-destination**: Local destination folder

Examples:

    my-local-putio -t 123 -l Downloads
    my-local-putio -l Downloads --token 123

With Token variable (inline or exporting):

      PUTIO_TOKEN=123 my-local-putio -l Downloads

      export PUTIO_TOKEN=123
      my-local-putio --local-destination Downloads/

#### Others attributes:
* **-h**: Print the help usage message
* **-s** or **--silent**: Hide all messages and progress bar
* **-d** or **--debug**: Developer mode: Prints everything and expose URLs with tokens for debug purposes.

Examples:

    my-local-putio -h
    my-local-putio -t 123 -l Downloads --silent
    my-local-putio -t 123 -l Downloads -s
    my-local-putio --local-destination Downloads -t 123 --debug

Verbose output example:

    [LOG][2019-07-18 11:11:30] Getting files for Downloads
    [LOG][2019-07-18 11:11:31] Getting files for Downloads/ubuntu-18.04.2-desktop-amd64.iso
    [LOG][2019-07-18 11:11:31] Downloading: Downloads/ubuntu-18.04.2-desktop-amd64.iso
    ######################################################################## 100.0%

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
