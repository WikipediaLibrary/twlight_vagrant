# twlight_vagrant Host-side File Management

If you prefer to work from the host environment, you can use any combination of browsing and editing tools that support SSH. You'll still need to run helper scripts, restart services, and commit changes as usual. You can get the ssh connection information by running vagrant ssh-config, e.g.

```
$ vagrant ssh-config
Host default
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/$USER/Projects/vagrant/twlight_vagrant/.vagrant/machines/default/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
  ForwardAgent yes
```
Where $USER is your linux username

## Notes for Windows users:

You will need to modify the IdentityFile path above in order to access the private key from a Windows application. Modifying Windows Subsystem for Linux files outside of the linux environment will break your linux environment, but allowing your application to read the SSH key should be safe. The location of your home directory differs between store-based installs (recommended, what you probably have) and lxrun-based installs (deprecated). All references here will be for the store-based Ubuntu install.

The store-based Ubuntu home directory is:

```
%localappdata%\Packages\CanonicalGroupLimited.UbuntuonWindows_$somevalue\LocalState\rootfs\home\$USER
```

where $USER is your linux username and $somevalue is not consistent across installations. For convenience, you may run [bin/get_winpath_for_wsl_homedir.sh](bin/get_winpath_for_wsl_homedir.sh) from the twlight_vagrant directory in Ubuntu, which will print the windows path to your Ubuntu home directory:


```
./bin/get_winpath_for_wsl_homedir.sh
```

To that path, add the path to the private key for the TWLight Vagrant machine that gets created upon "vagrant up." For example

```
Projects\vagrant\twlight_vagrant\.vagrant\machines\default\virtualbox\private_key
```

In this case, the full path to your TWLight Vagrant machine's IdentityFile would be something like:

```
%localappdata%\Packages\CanonicalGroupLimited.UbuntuonWindows_$somevalue\LocalState\rootfs\home\$USER\Projects\vagrant\twlight_vagrant\.vagrant\machines\default\virtualbox\private_key
```

## FileZilla example (Linux, MacOS, or Windows)

[FileZilla](https://filezilla-project.org/) is a multiplatform FTP, FTPS, and SFTP client that can work with pretty much any host-side application.

1. Under File, select "Site Manager"
2. Click "New Site"
3. Give the site a creative name, such as "twlight_vagrant" and click OK
4. Set the following values:

```
General:
  Host: vagrant ssh-config HostName
  Port: vagrant ssh-config port
  Protocol: SFTP - SSH File Transfer Protocol
  Logon Type: Key file
  User: vagrant
  Key file: vagrant ssh-config IdentityFile (Windows users modify path as noted)
Advanced:
  Default remote directory: /var/www/html/TWLight
```

5. Click "OK"

You may now use your saved site to browse and edit files in the guest, as well as drag and drop files from your host system into the guest.

## Cyberduck example (MacOS or Windows)

[Cyberduck](https://cyberduck.io/) is a general-purpose cloud and server storage browser that can work with pretty much any host-side application.

### Set relevant preferences in Cyberduck

1. Under Edit, select "Preferences"
2. Under General, set "Default protocol" to "SFTP (SSH File Transfer Protocol)"
3. Under Editor, set the default text editor to the application of your choice

### Create a connection to your TWLight Vagrant machine and bookmark it

1. Click "Open Connection"
2. Expand the "More Options" section.
3. Set the following values:

```
Protocol: SFTP (SSH File Transfer Protocol)
Server: vagrant ssh-config HostName
Port: vagrant ssh-config port
Username: vagrant
SSH Private Key: vagrant ssh-config IdentityFile (Windows users modify path as noted)
Save Password: Unchecked
Path: /var/www/html/TWLight
```

4. Click "Connect"
5. Under Bookmark, Select "New Bookmark"
3. Give the bookmark a creative name, such as "twlight_vagrant" and close the window
4. You can now toggle bookmarks under the Bookmark menu

You may now use your bookmarked connection to browse and edit files in the guest, as well as drag and drop files from your host system into the guest.

## Notepad++ example (Windows only)

[Notepad++](https://notepad-plus-plus.org/) is a Windows-only text/code editor with a rich plugin ecosystem. You can configure it to directly manage files via SSH by using an unstable plugin.

### Install the NppFTP Plugin

1. Under Plugins -> Plugin Manager, Select "Show Plugin Manager"
2. Under Settings, Select "Show unstable plugins" and click OK
3. Attempt to install the NppFTP plugin.
4. You will be prompted to update the plugin manager before proceeding with the NppFTP installation. Allow the update, but when asked if you would like to automatically restart, select "No", then manually exit.
5. Open Notepad++ again and install the NppFTP plugin.
6. Under Plugins -> NppFTP, select "Show NppFTP Window"

### Create a profile to connect to your TWLight Vagrant machine in the NppFTP window

1. Under the Settings gear, Select "Profile settings"
2. Click "Add new"
3. Give the profile a creative name, such as "twlight_vagrant" and click OK
4. Set the following values:

```
Connection:
  Hostname: vagrant ssh-config HostName
  Connection type: SFTP
  Port: vagrant ssh-config port
  Username: vagrant
  Initial remote directory: /var/www/html/TWLight
Authentication:
  Try private key file authentication: Checked
  Try password authentication: Unchecked
  Private key file: vagrant ssh-config IdentityFile (Windows users modify path as noted)
```

You may now use the (Dis)Connect icon in the NppFTP window to browse and edit files in the guest, as well as drag and drop files from your host system into the guest.
