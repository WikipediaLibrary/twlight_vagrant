# twlight_vagrant

## Overview

Deploys and configures the [Library Card Platform for The Wikipedia Library](https://github.com/WikipediaLibrary/TWLight) in a vagrant environment.

## Audience

Those developing [Library Card Platform for The Wikipedia Library](https://github.com/WikipediaLibrary/TWLight).

## Requirements
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* vagrant-vbguest plugin (eg. vagrant plugin install vagrant-vbguest)
* Browser configured to hit a local SOCKS proxy on a port of your choice, I use 2080

## Optional
* Host-side editing tools that can operate over SSH

## Example FoxyProxy Config:

I like to use the [FoxyProxy Standard addon for Firefox](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/) and match on URL patterns.
Proxy:
```
Title:      Vagrant
Proxy Type: SOCKS5
Proxy DNS?: On
IP Address: 127.0.0.1
Port:       2080
```
White Patterns:
```
Name:       Vagrant
Pattern:    *.vagrant.localdomain*
Type:       wildcard
http(s):    both
On/Off:     on
```

## Notes for Linux users:
For a "just works" experience, I recommend fetching Vagrant and Virtualbox packages from the vendor websites rather than using your distribution's software repositories. Those likely include fairly old versions of the required packages, and you will find yourself having to carefully managing your Vagrant, Virtualbox, and base box updates to avoid breakage, if it's not broken out of the gate.

## Notes for Windows users:
I strongly recommend using Vagrant's (early but generally working) support for Ubuntu on Windows via the Windows Subsystem for Linux. You should be on Windows 10 Version 1709 or later. See the [Vagrant and Windows Subsystem for Linux instructions](https://www.vagrantup.com/docs/other/wsl.html). You'll install Virtualbox on the Windows side, and then install exactly the same build of Vagrant in both Windows and Ubuntu on Windows. The Linux notes apply to the Ubuntu on Windows environment. Just download a fixed version of Vagrant (that matches the version you install in Windows) and install using dpkg as described in the instructions. Install any plugins in the Ubuntu on Windows environment.

## Usage

Clone this repository, which is where you will be running Vagrant.

You will probably need to tweak some of the settings for the [puppet module](https://github.com/WikipediaLibrary/twlight_puppet); to do so, edit the values in
```
./manifests/default.pp
```

If you have a DB dump that you'd like to load on provision, place it

```
./imports/twlight.sql
```

You'll need to use an SSH SOCKS proxy to access the web interface.
To do so specify a dynamic tunnel when you vagrant ssh, e.g.
```
vagrant up
vagrant ssh -- -D 2080

```
Then point a browser (configured to use your proxy on 2080 to:
[http://twlight.vagrant.localdomain](http://twlight.vagrant.localdomain)

You can now work on the running app inside Vagrant and view the changes in your browser.
As you are making local changes, make sure to take advantage of the included test suite. To do so, run the following command within the vagrant machine:

```
sudo su www /var/www/html/TWLight/bin/virtualenv_test.sh
```

## Editing guest files from host (Advanced)

If you prefer to work from the host environment, you can use any editing tools that support SSH. You'll still need to run helper scripts, restart services, and commit changes as usual. You can get the ssh connection information by running vagrant ssh-config, e.g.

```
$ vagrant ssh-config
Host default
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/???/Projects/vagrant/twlight_vagrant/.vagrant/machines/default/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
  ForwardAgent yes
```
Where ??? is your linux username

### Notes for Windows users:

You will need to modify the IdentityFile path above in order to access the private key from a Windows application. You should never modify Windows Subsystem for Linux files outside of the linux environment, but allowing your application to read the SSH key should be safe. The WSL home directory is:

```
%localappdata%\Lxss\home\???
```

where ??? is your linux username, e.g. the full path to your TWLight Vagrant machine's IdentityFile would be something like:

```
%localappdata%\Lxss\home\???\Projects\vagrant\twlight_vagrant\.vagrant\machines\default\virtualbox\private_key
```

### Cyberduck example (MacOS or Windows)

[Cyberduck](https://cyberduck.io/) is a general-purpose cloud and server storage browser that can work with pretty much any host-side application.

#### Set relevant preferences in Cyberduck

1. Under Edit, select "Preferences"
2. Under General, set "Default protocol" to "SFTP (SSH File Transfer Protocol)"
3. Under Editor, set the default text editor to the application of your choice

#### Create a connection to your TWLight Vagrant machine and bookmark it

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

### Notepad++ example (Windows only)

[Notepad++](https://notepad-plus-plus.org/) is a Windows-only text/code editor with a rich plugin ecosystem. You can configure it to directly edit files via SSH by using an unstable plugin.

#### Install the NppFTP Plugin

1. Under Plugins -> Plugin Manager, Select "Show Plugin Manager"
2. Under Settings, Select "Show unstable plugins" and click OK
3. Attempt to install the NppFTP plugin.
4. You will be prompted to update the plugin manager before proceeding with the NppFTP installation. Allow the update, but when asked if you would like to automatically restart, select "No", then manually exit.
5. Open Notepad++ again and install the NppFTP plugin.
6. Under Plugins -> NppFTP, select "Show NppFTP Window"

#### Create a profile to connect to your TWLight Vagrant machine in the NppFTP window

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
