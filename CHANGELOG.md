# v4.0.1

- More code refactoring

# v4.0.0

- Introducing with subtitles option
- Breaking changes parameters
  - removed -s option for --silent. Now silent is only available as --silent
  - introduced -s option for --with-subtitles
- More code refactoring

# v3.0.1

- Fix for delete-remote that was not enabling/disabling properly.

# v3.0.0

- Introducing delete from remote after downloading
- Breaking changes parameters
  - removed -d option for --debug. Now debug is only available as --debug
  - introduced -d option for --delete-remote
- More code refactoring

# v2.1.0

- Introducing SOCKS5 support with `--socks5-proxy` option.
- Adding `--version` option
- Small refactoring for error handling during the boot

# v2.0.0

- Breaking changes parameters
  - --verbose (-v) was removed. By default all messages will be printed out.
  - --silent option was introduced to mute the output.
  - --destination (-d) was removed and replaced by --local-destination
  - introduced -d option for --debug


# v1.0.1

- Fixing small require bug

# v1.0.0

- Rename from *put.io fetcher* to *my local put.io* in order to have more features (and not limited only to fetch files)

# v0.1.0

- First release as gem version
