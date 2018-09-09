# -*- mode: ruby -*-
# vi: set ft=ruby :

twlight_puppet_version = "0.5.3"

# Put "--debug " in this string if you want to test the limits of your terminal
# emulator's buffer.
twlight_puppet_options = "--confdir /vagrant/puppet --codedir /vagrant/puppet"
twlight_puppet_bin_path = "/opt/puppetlabs/puppet/bin"

Vagrant.configure("2") do |config|

  # Name this thing
  config.vm.define "twlight"
  config.vm.hostname = "twlight.vagrant.localdomain"

  if File.exists?(File.join(Dir.home, ".gitconfig"))
    # Read local machine's gitconfig (~/.gitconfig)
    gitconfig = File.read(File.join(Dir.home, ".gitconfig"))
    # Copy it to VM as the /etc/gitconfig
    config.vm.provision :shell, :inline => "echo 'Copying local Git config to VM...' && echo '#{gitconfig}' > /etc/gitconfig"
  #else
  #  # Else, throw a Vagrant Error. Cannot successfully startup on Windows without a GitHub SSH Key!
  #  raise Vagrant::Errors::VagrantError, "\n\nERROR: GitHub SSH Key not found at ~/.ssh/github_rsa.\n\n"
  end

  # Forward SSH agent from host into Vagrant machine
  config.ssh.forward_agent = true
  config.ssh.password = "vagrant"

  # Our provisioner expects /vagrant.
  config.vm.synced_folder ".", "/vagrant"


  # We need a little beef if we're pulling in production-scale data
  config.vm.provider :virtualbox do |v|
    # roughly tracking twlight VMs provisioned via wikimedia labs horizon
    v.box = "bento/debian-8"
    v.cpus = 4
    v.memory = 4096
    v.linked_clone = true
  end

  # Build container from Dockerfile
  config.vm.provider "docker" do |d|
    d.build_dir = "."
    d.has_ssh = true
    d.create_args = ["--cap-add", "SYS_ADMIN", "-v", "/run", "-v", "/tmp", "-v", "/sys/fs/cgroup:/sys/fs/cgroup:ro"]
  end

  # Allow the SSH agent to cross the sudo barrier.
  # Handy if you use an SSH remote and want to run the git pull script (which require root).
  config.vm.provision "shell",
      inline: "echo 'Defaults    env_keep+=SSH_AUTH_SOCK' | sudo EDITOR='tee -a' visudo"

  # Install puppet because we need it, chrony because its useful in Vagrant,
  # and vim because the author of this Vagrantfile prefers it.
  config.vm.provision "shell",
    inline: "wget --quiet --timestamping --directory-prefix=/tmp \
        https://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb && \
        dpkg -i /tmp/puppetlabs-release-pc1-jessie.deb && \
        apt update && apt install -y chrony puppet-agent vim"


  # Add github's host key to our known hosts file
  config.vm.provision "shell",
    inline: "ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts"

  # Kill the SSHD process we used to bootstrap, and start a proper service.
  config.vm.provision "shell",
    inline: "/usr/bin/pkill sshd && /bin/systemctl start ssh"

  # frontload some vagrant-specific systemd config.
  config.vm.provision "shell",
    inline: "mkdir -p /etc/systemd/system/mariadb.service.d; \
        printf '[Service]\nProtectHome=false\nType=simple\n' > /etc/systemd/system/mariadb.service.d/vagrant.conf; \
        systemctl daemon-reload"

  ## Handy method for fetching puppet module from github
  #config.vm.provision "shell",
  #  inline: "wget --quiet --timestamping --directory-prefix=/vagrant/puppet/modules \
  #		  'https://github.com/WikipediaLibrary/twlight_puppet/archive/"+ twlight_puppet_version +".tar.gz'"

  ## Install our twlight puppet module from github
  #config.vm.provision "shell",
  #  inline: twlight_puppet_bin_path +"/puppet module install \
  #    "+ twlight_puppet_options +" --target-dir /vagrant/puppet/modules \
  #    /vagrant/puppet/modules/"+ twlight_puppet_version +".tar.gz"

  # Install our twlight puppet module from puppet forge
  config.vm.provision "shell",
    inline: twlight_puppet_bin_path +"/puppet module install \
      "+ twlight_puppet_options +" --target-dir /vagrant/puppet/modules \
      jsnshrmn/twlight --version "+ twlight_puppet_version +";"

  # Run the puppet provisioner
  config.vm.provision "puppet" do |puppet|
    puppet.working_directory = "/vagrant/puppet"
    puppet.hiera_config_path = "puppet/hiera.yaml"
    puppet.environment = "local"
    puppet.environment_path = "puppet/environments"
    puppet.module_path = "puppet/modules"
    puppet.binary_path = twlight_puppet_bin_path
    puppet.options = twlight_puppet_options

  # Run migration so any imported DB dump will work with current code.
  config.vm.provision "shell",
    inline: "sudo su www bash -c '/var/www/html/TWLight/bin/./virtualenv_migrate.sh >>/var/www/html/TWLight/TWLight/logs/update.log 2>&1' || :"

  # Allow vagrant user to write to project .git
  config.vm.provision "shell",
    inline: "usermod -a -G www vagrant && chmod -R g+w /var/www/html/TWLight"

  end
end
