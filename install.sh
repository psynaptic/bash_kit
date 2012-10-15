#!/bin/bash

# Get the directory of this script.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set the bash_kit profile file location.
BASH_KIT_PROFILE="$HOME/.bash_kit_profile"

# Set the ZSH profile if it exists.
if [ -f "$HOME/.zshrc" ]; then
  ZSH_PROFILE="$HOME/.zshrc"
fi

# Calculate the bash profile file location.
# 
# Prefer .bashrc as it's sourced for non-login shells.
if [ -f "$HOME/.bashrc" ]; then
  PROFILE="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
  PROFILE="$HOME/.bash_profile"
elif [ -f "$HOME/.profile" ]; then
  PROFILE="$HOME/.profile"
fi

# Add the enviroment variables to a new config file.
cat << EOF >> $BASH_KIT_PROFILE
# Set the Bash Kit environment variables.
export BASH_KIT_DIR="$DIR"
export BASH_PROFILE="$PROFILE"
export DRUSH_PATH="$(which drush)"
export DB_USER="root"
export DB_PASS=""
export PATH=\$DRUSH_PATH:\$PATH
export VC_AUTOPUSH=0
export LC_CTYPE="en_US.UTF-8"
export LANG="en_US.UTF-8"

EOF

DATA=$(cat <<"EOF"
\n
# Import bash_kit.\n
if [ -f '$DIR/profile' ]; then\n
  source '$DIR/profile'\n
fi\n
\n
EOF
)

# If ZSH is set to something meaningful, append to both profiles.
if [ -n $ZSH_PROFILE ]; then
  echo $DATA >> $PROFILE
  echo $DATA >> $ZSH_PROFILE
else
  echo $DATA >> $PROFILE
fi

cat << EOF
Run the following command to complete the installation of Bash Kit:

source $PROFILE
EOF

