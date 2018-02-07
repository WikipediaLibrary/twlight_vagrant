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
