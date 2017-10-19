# twlight_vagrant

## Overview

Deploys and configures the [Library Card Platform for The Wikipedia Library](https://github.com/WikipediaLibrary/TWLight) in a vagrant environment.

## Audience

Those developing [Library Card Platform for The Wikipedia Library](https://github.com/WikipediaLibrary/TWLight).

## Requirements
* Vagrant
* Virtualbox
* vagrant-vbguest plugin
* Browser configured to hit a local SOCKS proxy on a port of your choice, I use 2080


I like to use the [FoxyProxy Standard addon for Firefox](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/),
and match on URL patterns.

If you have a DB dump that you'd like to load on provision, place it

```
./imports/twlight.sql
```

## Usage

Expects you to use an SSH SOCKS proxy. rather than messing around with Vagrant port mapping,
which can have implications for backend apps.
```
vagrant up
vagrant ssh -- -D 2080

```
Then point a browser (configured to use your proxy on 2080 to:
[http://twlight.vagrant.localdomain](http://twlight.vagrant.localdomain)

As you are making local changes, make sure to take advantage of the included test suite. To do so, run the following command within the vagrant machine:

```
sudo su www /var/www/html/TWLight/bin/virtualenv_test.sh
```



## Known issues

Updating to Firefox 55+ recently replaced FoxyProxy Standard 4.x with FoxyProxy Standard 5.x, as 5.x supports the new Firefox extension framework called WebExtensions. Firefox is now replacing any extensions with a newer WebExtensions version if it is available, since WebExtensions will be the only supported extensions framework starting in Firefox 57. As of early September 2017, the new version doesn't support the SOCKS proxy as described in this README, so you may wish to downgrade to 4.x if you find yourself unable to reach your vagrant machine.
