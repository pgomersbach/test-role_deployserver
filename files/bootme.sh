#!/usr/bin/env bash
#
# This script installs puppet 3.x or 4.x and deploy the manifest using puppet apply -e "include role_deployserver"
#
# Usage:
# Ubuntu / Debian: wget https://raw.githubusercontent.com/pgomersbach/test-role_deployserver/master/files/bootme.sh; bash bootme.sh
#
# Red Hat / CentOS: curl https://raw.githubusercontent.com/pgomersbach/test-role_deployserver/master/skeleton/files/bootme.sh -o bootme.sh; bash bootme.sh
# Options: add 3 as parameter to install 4.x release

# default major version, comment to install puppet 3.x
PUPPETMAJORVERSION=4

### Code start ###
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if [ "$#" -gt 0 ]; then
   if [ "$1" = 3 ]; then
     PUPPETMAJOR=3
     MODULEDIR="/etc/puppet/modules/"
   else
     PUPPETMAJOR=4
     MODULEDIR="/etc/puppetlabs/code/modules/"
  fi
else
  PUPPETMAJOR=$PUPPETMAJORVERSION
fi

# install dependencies
if which apt-get > /dev/null 2>&1; then
    apt-get update
  else
    echo "Using yum"
fi

apt-get install git bundler zlib1g-dev -y || yum install -y git bundler zlib-devel

# get or update repo
if [ -d /root/role_deployserver ]; then
  echo "Update repo"
  cd /root/role_deployserver
  git pull
else
  echo "Cloning repo"
  git clone https://github.com/pgomersbach/test-role_deployserver /root/role_deployserver
  cd /root/role_deployserver
fi

# install puppet if not installed
if which puppet > /dev/null 2>&1; then
    echo "Puppet is already installed."
  else
    bash /root/role_deployserver/files/bootstrap.sh $PUPPETMAJOR
fi

# prepare bundle
echo "Installing gems"
bundle install --path vendor/bundle
# install dependencies from .fixtures
echo "Preparing modules"
bundle exec rake spec_prep
# copy to puppet module location
cp -a /root/role_deployserver/spec/fixtures/modules/* $MODULEDIR
echo "Run puppet apply"
puppet apply -e "include role_deployserver"
