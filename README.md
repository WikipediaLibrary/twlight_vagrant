# twlight_vagrant

## Overview

Deploys and configures the [Library Card Platform for The Wikipedia Library](https://github.com/WikipediaLibrary/TWLight) in a vagrant environment.

## Audience

Those developing [Library Card Platform for The Wikipedia Library](https://github.com/WikipediaLibrary/TWLight).

## Requirements
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox and VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)
* vagrant-vbguest plugin (eg. vagrant plugin install vagrant-vbguest)
* Browser configured to hit a local SOCKS proxy on a port of your choice, I use 2080

## Optional
* Host-side file manager that can operate over SSH. This allows you to work on the project using native applications on your computer, rather than using CLI tools in the TWLight Vagrant machine. See [twlight_vagrant Host-side File Management](docs/host_side_file_management.md).
* FoxyProxy Standard to automatically proxy only vagrant URLs. This removes the hassle of having to regularly enable/disable a proxy. See [twlight_vagrant FoxyProxy Standard Configuration](docs/foxyproxy.md).

## Notes for Linux users:

For a "just works" experience, I recommend fetching Vagrant and VirtualBox packages from the vendor websites rather than using your distribution's software repositories. Those likely include fairly old versions of the required packages, and you will find yourself having to carefully managing your Vagrant, VirtualBox, and base box updates to avoid breakage, if it's not broken out of the gate.

## Notes for Windows users:

Some third-party endpoint security software, such as Dell Data Protection Encryption and several McAfee products, interfere with VirtualBox. You may need to temporarily disable these products or make different endpoint protection choices. 

You'll need to add the following directory to your PATH environment variable after installing VirtualBox:

```
C:\Program Files\Oracle\VirtualBox
```

See [this example from Microsoft](https://msdn.microsoft.com/en-us/library/office/ee537574.aspx) for adding a path to the PATH environment variable.

Vagrant's (early but generally working) support for Ubuntu via the Windows Subsystem for Linux is the recommended way to run this enviroment. You should be on Windows 10 Version 1709 or later and perform a store-based Ubuntu installation. See the [Vagrant and Windows Subsystem for Linux instructions](https://www.vagrantup.com/docs/other/wsl.html). You'll install VirtualBox on the Windows side, and then install exactly the same build of Vagrant in both Windows and Ubuntu. The Linux notes apply to the Ubuntu environment. Just download a fixed version of Vagrant (that matches the version you install in Windows) and install using dpkg as described in the instructions. Install any plugins in Ubuntu.

On Vagrant 2.0.2 and earlier, [issue #9298](https://github.com/hashicorp/vagrant/issues/9298) means you'll need create a symlink in the location of the deprecated lxrun installation that points to the new store-based installation. As pointed out in the reported issue, running the following powershell commands on the windows side will pull the information from the registry and create the appropriate symlink.

```
$WSLREGKEY="HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss"
$WSLDEFID=(Get-ItemProperty "$WSLREGKEY").DefaultDistribution
$WSLFSPATH=(Get-ItemProperty "$WSLREGKEY\$WSLDEFID").BasePath
New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\lxss" -Value "$WSLFSPATH\rootfs"
```

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
Then point a browser (configured to use your proxy on 2080) to:
[http://twlight.vagrant.localdomain](http://twlight.vagrant.localdomain)

You can now work on the running app inside Vagrant and view the changes in your browser.
As you are making local changes, make sure to take advantage of the included test suite. To do so, run the following command within the vagrant machine:

```
sudo su www /var/www/html/TWLight/bin/virtualenv_test.sh
```
