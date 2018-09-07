#!/usr/bin/env bash

echo "export VISIBLE=now" >> /etc/profile

apt update && apt install -y dialog gnupg lsb-release openssh-server python-minimal sudo systemd wget

mkdir -p /var/run/sshd 

mkdir -p /run/systemd 

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
