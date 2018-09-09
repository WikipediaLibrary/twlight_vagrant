#!/usr/bin/env bash

echo "export VISIBLE=now" >> /etc/profile

# Install packages.
# Basic vagrant workflow for faking real hosts needs locales openssh-server sudo and systemd.
# Puppet provisioner needs lsb-release. Puppet apt module needs gnupg for adding encrypted repos.
# TWLight vagrant shell provisioner expects wget.
apt update && apt install -y dialog gnupg lsb-release locales openssh-server sudo systemd wget

# Lie if anyone anyone asks if we booted up with systemd.
# https://www.freedesktop.org/software/systemd/man/sd_booted.html
mkdir -p /run/systemd/system

# Strip out bits that aren't going to work happily in this container. Largely cribbed from:
# https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done);
rm -f /lib/systemd/system/multi-user.target.wants/*;
rm -f /etc/systemd/system/*.wants/*;
rm -f /lib/systemd/system/local-fs.target.wants/*;
rm -f /lib/systemd/system/sockets.target.wants/*udev*;
rm -f /lib/systemd/system/sockets.target.wants/*initctl*;
rm -f /lib/systemd/system/basic.target.wants/*;
rm -f /lib/systemd/system/anaconda.target.wants/*;
# With these additions that @jsnshrmn found to be problematic, at least on Debian 9.
rm -f /lib/systemd/system/user\@.service
rm -r /lib/systemd/system/systemd-tmpfiles-setup.service
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-journald.service ] || rm -f $i; done);

# Prep us running SSH from a shell.
mkdir -p /var/run/sshd

# SSH login fix. Otherwise user is kicked off after login
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Configure insecure root user for Vagrant
echo 'root:vagrant' | chpasswd 
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Add vagrant user
adduser --quiet --disabled-password --shell /bin/bash --home /home/vagrant --gecos "User" vagrant
echo 'vagrant:vagrant' | chpasswd

# Setup vagrant insecure key.
mkdir -p /home/vagrant/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' >>/home/vagrant/.ssh/authorized_keys
chown -R 'vagrant:vagrant' /home/vagrant/.ssh 
chmod 600 /home/vagrant/.ssh/authorized_keys
chmod 700 /home/vagrant/.ssh

# Setup passwordless sudo for vagrant user.
echo 'vagrant         ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers
