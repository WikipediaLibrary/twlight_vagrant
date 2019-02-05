# twlight_vagrant

## Overview

Deploys and configures the [Library Card Platform for The Wikipedia Library](https://github.com/WikipediaLibrary/TWLight) in a vagrant environment.

## Audience

Those developing [Library Card Platform for The Wikipedia Library](https://github.com/WikipediaLibrary/TWLight).

## Requirements
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Docker](https://www.docker.com/get-started)
* Browser configured to hit a local SOCKS proxy on a port of your choice, I use 2080

## Optional
* Host-side file manager that can operate over SSH. This allows you to work on the project using native applications on your computer, rather than using CLI tools in the TWLight Vagrant machine. See [twlight_vagrant Host-side File Management](docs/host_side_file_management.md).
* FoxyProxy Standard to automatically proxy only vagrant URLs. This removes the hassle of having to regularly enable/disable a proxy. See [twlight_vagrant FoxyProxy Standard Configuration](docs/foxyproxy.md).

## Notes for Linux users:

For a "just works" experience, I recommend fetching Vagrant and Docker packages from the vendor websites rather than using your distribution's software repositories. Those likely include fairly old versions of the required packages, and you will find yourself having to carefully managing your component updates to avoid breakage, if it's not broken out of the gate.

## Notes for Windows users:

Some third-party endpoint security software, such as Dell Data Protection Encryption and several McAfee products, interfere with VirtualBox. You may need to temporarily disable these products or make different endpoint protection choices. 

Vagrant's (early but generally working) support for Ubuntu via the Windows Subsystem for Linux is the recommended way to run this enviroment. You should be on Windows 10 Version 1709 or later and perform a store-based Ubuntu installation. See the [Vagrant and Windows Subsystem for Linux instructions](https://www.vagrantup.com/docs/other/wsl.html). Then:

 * Install Docker on Windows and enable legacy mode (Expose daemon on tcp://localhost:2375 without TLS)
 * Install Docker on Ubuntu. You can just use the Ubuntu-provided package, eg. `apt install docker.io`
 * Install Vagrant on Ubuntu using dpkg as described in the Vagrant instructions. If you already have Vagrant on Windows, you'll need to keep the two at exactly the same build version.
 * When you clone this repository in Ubuntu, make sure to do so in a location accessible to Windows, such as ``/mnt/c/Users/Username/v`` (``/mnt/c/`` corresponds to ``C:\``). This is required for the vagrant share to work properly.
 * There are a number of environment variables that should be configured for WSL + Docker + Vagrant to work happily. As a convenience, you may just ``source bin/wsl_docker_activate.sh`` from within the project directory.
 
The Linux notes apply to the Ubuntu environment.

## Usage

Clone this repository, which is where you will be running Vagrant.

You might need to configure some of the settings for the [puppet module](https://github.com/WikipediaLibrary/twlight_puppet); to do so, create the following yaml file:
```
./puppet/data/nodes/twlight.vagrant.localdomain.yaml
```
and configure any parameters you'd like to override, such as the git repository or revision. See the [parameters manifest in the puppet module](https://github.com/WikipediaLibrary/twlight_puppet/blob/master/manifests/params.pp).

If you have a TWLight backup tarball that you'd like to load on provision, place it

```
./backup/twlight.tar.gz
```

Alternatively, scripts are included to create a superuser and generate example data. Before doing anything else, login to the platform as normal, then run

```
sudo -u www /var/www/html/TWLight/bin/virtualenv_example_data.sh
```

The account you used to login will be made a superuser, giving you access to the Admin interface. The values in that file can be modified to generate more or less users, partners, and applications, but the file should only be run once.

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
