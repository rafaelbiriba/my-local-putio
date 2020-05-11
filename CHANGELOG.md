# ?

- Introducing --detailed-progress
  - Display the default curl output with a detailed information of the download, instead of a simple progress bar.

# v4.3.1

- Bugfix: Already downloaded files no longer need to be downloaded again
  - No parameter is necessary this is the default behaviour
  - The codes matches the name and the filesize

# v4.3.0

- Introducing --disk-threshold
  - Check if there is enough space on the disk (download/temporary folder) before download another file

# v4.2.0

- Introducing temporary destination
  - By default the temporary destination for files will be your local destination + "incomplete_downloads"
  - You can overwrite the temporary directory with the option --temp-destination

# v4.1.0

- Change download order from put.io:
  - Main Directory: Ordered by added dated `desc`, older will start first
  - Subfolder: Ordered by Name
  - With this changes the script will start download the older folder, and will start download the episode n1 from that folder.
  - Example: The main dir have `new_folder1/video1.mp4`, `new_folder2/video2.mp4`, `old_folder/video1.mp4`, `old_folder/video2.mp4` before this changes the script will download using the last defined by the user (at the interface), so the behaviour would be different based on the user preferences. With the new changes, the first to download will be `old_folder/video1.mp4`, and then `old_folder/video2.mp4`.

# v4.0.2

- More code refactoring
  - Put.io api /files/<id>/download is deprecated. Replacing to /files/<id>/url

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
