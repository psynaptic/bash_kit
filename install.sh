set -e

export BASH_KIT_DIR=$HOME/.kit

if [ -d $BASH_KIT_DIR ]; then
  echo "\033[0;31mBash Kit is already installed. Please remove $BASH_KIT_DIR if you want to re-install.\033[0m"
  exit 1
fi

echo "\033[0;33mInstalling Bash Kit...\033[0m"
hash git &>/dev/null || {
  echo "\033[0;31mgit not installed\033[0m"
}
git clone https://github.com/psynaptic/bash_kit.git $BASH_KIT_DIR

# Calculate the bash profile file location.
if [ -f "$HOME/.profile" ]; then
  PROFILE="$HOME/.profile"
elif [ -f "$HOME/.bash_profile" ]; then
  PROFILE="$HOME/.bash_profile"
elif [ -f "$HOME/.bashrc" ]; then
  PROFILE="$HOME/.bashrc"
fi

cat << EOF >> $PROFILE

export BASH_PROFILE=$PROFILE
export BASH_KIT_DIR=$BASH_KIT_DIR

if [ -d \$BASH_KIT_DIR ]; then
  if [ "\$BASH" -o "\$ZSH" ]; then
    if [ -f $BASH_KIT_DIR/profile ]; then
      . $BASH_KIT_DIR/profile
    fi
  fi
fi

EOF

echo "\033[0;33mSourcing $PROFILE\033[0m"
. $PROFILE

echo "\033[0;32mDone\033[0m"
