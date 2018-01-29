Vagrant.configure("2") do |config|

  # roughly tracking twlight vms provisioned via wikimedia labs horizon
  config.vm.box = "bento/debian-8.9"
  #config.vm.box_version = ""

  # We need a little beef if we're pulling in production-scale data
  config.vm.provider :virtualbox do |v|
    v.cpus = 4
    v.memory = 4096
    v.linked_clone = true
  end

  # Our pupet provisioner expects /vagrant, and virtualbox is the only tested provider
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    config.vbguest.auto_update = true
    # dump our static hosts file in
    config.vm.provision "shell",
      inline: "cp /vagrant/hosts /etc/hosts"

    # Install puppet because we need it, and vim because the author of this Vagrantfile prefers it
    config.vm.provision "shell",
      inline: "apt-get install -y chrony puppet vim"

    # Install our twlight puppet module
    config.vm.provision "shell",
      inline: "puppet module install --target-dir /vagrant/modules \
        jsnshrmn/twlight --version 0.2.6;"

    # Run the puppet provisioner
    config.vm.provision "puppet" do |puppet|
      puppet.module_path = "modules"

    config.vm.provision "shell",
      inline: "sudo su www bash -c '/var/www/html/TWLight/bin/./virtualenv_migrate.sh >>/var/www/html/TWLight/TWLight/logs/update.log 2>&1' || :"

    end

  end

end
