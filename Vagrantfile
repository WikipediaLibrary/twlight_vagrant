Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-8.7"
  config.vm.box_version = "2.3.3"
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    config.vbguest.auto_update = true
    config.vm.provision "shell",
      inline: "cp /vagrant/hosts /etc/hosts"
    config.vm.provision "shell",
      inline: "mkdir -p /vagrant/modules"
    config.vm.provision "shell",
      inline: "mkdir -p /vagrant/imports"
    config.vm.provision "shell",
      inline: "mkdir -p /vagrant/dumps"
    config.vm.provision "shell",
      inline: "apt-get install -y puppet vim"
    config.vm.provision "shell",
      inline: "puppet module install --target-dir /vagrant/modules \
        jsnshrmn/twlight --version 0.1.10;"
    config.vm.provision "puppet" do |puppet|
      puppet.module_path = "modules"
    ## Work around issue in puppet module
    config.vm.provision "shell",
      inline: "mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -D mysql -u root -pvagrant; systemctl restart mysql && systemctl restart gunicorn"
    end
  end
end
