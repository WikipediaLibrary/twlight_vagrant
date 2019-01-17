# Step by step guide for installing twlight_vagrant

## Windows via WSL

This method, the recommended way to run the environment on Windows, makes use of [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

1. Install [Vagrant for Windows](https://www.vagrantup.com/downloads.html)
2. Install [VirtualBox for Windows, along with the VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)
3. Follow [this guidance](https://docs.microsoft.com/en-us/previous-versions/office/developer/sharepoint-2010/ee537574(v=office.14)) to add `C:\Program Files\Oracle\VirtualBox` to the PATH environment variable.
4. Ensure that you're on Windows 10 Version 1709 or later and install Windows Subsystem for Linux via the [Microsoft Store](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6).
5. `git clone https://github.com/wikipedialibrary/twlight_vagrant` into a windows directory (e.g. `mnt/c/Users/Sam/twlight_vagrant`)
6. Download the [Vagrant for Debian](https://www.vagrantup.com/downloads.html) (making sure this is the same version you installed on Windows)
7. Open Ubuntu and install Vagrant from that downloaded file with `dpkg -i [vagrant_file_name.deb]`
8. Install the vbguest plugin with `vagrant plugin install vagrant-vbguest`
9. Run `export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"` to enable WSL to access Windows files.
10. Do `vagrant up`. If everything has gone smoothly this should complete without errors.
11. You can now ssh into vagrant with `vagrant ssh -- -D 2080`
12. To view the site you will need to configure your browser to hit a SOCKS proxy on this port. Instructions for setting up FoxyProxy for this can be found at [foxyproxy.md](https://github.com/WikipediaLibrary/twlight_vagrant/blob/master/docs/foxyproxy.md).
13. For file management, a number of FTP guides can be found at [host_side_file_management.md](https://github.com/WikipediaLibrary/twlight_vagrant/blob/master/docs/host_side_file_management.md)

## Potential issues

### Vagrant will not operate outside the Windows Subsystem for Linux unless explicitly instructed

You probably missed step 9 above - `export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"`

### VT-x is disabled in the BIOS for both all CPU modes

You may need to go into your BIOS and enable Virtualisation or VT-x settings. You can follow a guide [such as this one](https://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/) to find the correct setting.

### Host path of the shared folder must be located on a file system with DrvFs type

This may appear if you are trying to `vagrant up` while in an Ubuntu directory (e.g. /home/Sam/twlight_vagrant). Try cloning to a Windows directory (e.g. `mnt/c/Users/Sam/twlight_vagrant`).
