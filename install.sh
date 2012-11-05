#!/usr/bin/env bash

# Get the directory of this script.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Calculate the bash profile file location.
if [ -f "$HOME/.profile" ]; then
  PROFILE="$HOME/.profile"
elif [ -f "$HOME/.bash_profile" ]; then
  PROFILE="$HOME/.bash_profile"
elif [ -f "$HOME/.bashrc" ]; then
  PROFILE="$HOME/.bashrc"
fi

cat << EOF >> $PROFILE

# Set the Bash Kit environment variables.
export BASH_KIT_DIR="$DIR"
export BASH_PROFILE="$PROFILE"
export DRUSH_PATH="$(which drush)"
export DB_USER="root"
export DB_PASS=""
export PATH=\$DRUSH_PATH:\$PATH
export VC_AUTOPUSH=0

# Import bash_kit
if [ "\$BASH" -o "\$ZSH" ]; then
  if [ -f "$DIR/profile" ]; then
    . "$DIR/profile"
  fi
fi

EOF

cat << EOF
Run the following command to complete the installation of Bash Kit:

source $PROFILE
EOF


