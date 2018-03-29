# The remote git repository that Vagrant will fetch TWLight from.
# Update this to your fork or branch as needed for development.
# To be able to push directly from within Vagrant, use the SSH URI instead of
# HTTPS and make sure your have your SSH key for git added to your key agent.
# You should definitely not try to do that against master.
$twlight_git_repository ='git@github.com:WikipediaLibrary/TWLight.git'
$twlight_git_revision = 'master'

# The Oauth configuration required to make signin to the site work as expected.
# The 'null' values are not functional.
$twlight_oauth_key = 'null'
$twlight_oauth_secret = 'null'

# These variables set config values for OS and package configuration as well as
# the app. If you don't know what they are then you don't need to change them.
$twlight_root_dir = '/var/www/html/TWLight'
$twlight_mysqlroot_pw = 'vagrant'
$twlight_mysqltwlight_pw = 'vagrant'
$twlight_restore_file = '/vagrant/backup/twlight.tar.gz'
$twlight_backup_dir = '/vagrant/backup'
$twlight_mysqldump_dir = '/var/www/html/TWLight'
$twlight_servername = 'twlight.vagrant.localdomain'
$twlight_serverport = '80'
$twlight_externalport = '80'
$twlight_environment = 'local'
$twlight_unixname = 'www'

# These variables set config values for the app.
# If you don't know what they are then you don't need to change them.
$twlight_secretkey = 'vagrant'
$twlight_allowedhosts = "['twlight.vagrant.localdomain']"
$twlight_baseurl = "http://${twlight_servername}/"
$twlight_oauth_provider_url = "https://meta.wikimedia.org/w/index.php"

# Actually calls the module. Don't change this.
class { 'twlight': }
