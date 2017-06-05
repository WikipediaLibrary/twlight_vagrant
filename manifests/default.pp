$twlight_git_revision = 'master'
$twlight_mysqlroot_pw = 'vagrant'
$twlight_mysqltwlight_pw = 'vagrant'
$twlight_mysqlimport = '/vagrant/imports/twlight.sql'
$twlight_mysqldumpdir = '/vagrant/dumps'
$twlight_servername = 'twlight.vagrant.localdomain'
$twlight_serverport = '80'
$twlight_externalport = '80'
$twlight_environment = 'vagrant'
$twlight_unixname = 'www'

$twlight_secretkey = 'vagrant'
$twlight_allowedhosts = "['twlight.vagrant.localdomain']"
$twlight_baseurl = "http://${twlight_servername}/"
$twlight_wpcredentials = "{'localhost': {'key': 'null', 'secret': 'null'}}"

class { 'twlight': }
