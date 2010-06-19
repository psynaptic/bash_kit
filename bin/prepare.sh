#!/bin/bash
# Prepare a drupal installation by setting permissions, copying files.
# Assume we are in the drupal root.
# TODO verify we are in the drupal root, use path argument if not.

CORE=${1:-6}

cp sites/default/default.settings.php sites/default/settings.php
chmod 666 sites/default/settings.php
mkdir sites/default/files
mkdir -p sites/all/modules/contrib
mkdir -p sites/all/modules/custom
mkdir -p sites/all/themes/contrib
mkdir -p sites/all/themes/custom
mkdir -p sites/all/libraries
chmod 777 sites/default/files

if [ $CORE == 7 ]
then
  mkdir -p sites/default/private/{files,temp}
  chmod 777 sites/default/private/files
fi
