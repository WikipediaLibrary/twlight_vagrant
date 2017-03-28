Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-8.7"
  config.vm.box_version = "2.3.3"
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    config.vbguest.auto_update = true
    config.vm.provision "shell",
      inline: "apt-get install -y puppet vim"
    config.vm.provision "shell",
      inline: "puppet module install --target-dir /vagrant/modules \
        jsnshrmn/twlight --version 0.1.5;"
    config.vm.provision "puppet" do |puppet|
      puppet.module_path = "modules"
    end
    config.vm.network :forwarded_port, guest: 80, host: 8000
  end
end
