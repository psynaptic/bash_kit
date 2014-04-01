set -e

export BASH_KIT_DIR=".kit"
export BASH_KIT_INSTALL="$HOME/$BASH_KIT_DIR"

if [ -d "$BASH_KIT_INSTALL" ]; then
  echo "\033[0;31mBash Kit is already installed. Please remove $BASH_KIT_INSTALL if you want to re-install.\033[0m"
  exit 1
fi

echo "\033[0;33mInstalling Bash Kit...\033[0m"
hash git &>/dev/null || {
  echo "\033[0;31mgit not installed\033[0m"
}
git clone https://github.com/psynaptic/bash_kit.git "$BASH_KIT_INSTALL"

# Calculate the bash profile file location.
if [ -f "$HOME/.profile" ]; then
  PROFILE=".profile"
elif [ -f "$HOME/.bash_profile" ]; then
  PROFILE=".bash_profile"
elif [ -f "$HOME/.bashrc" ]; then
  PROFILE=".bashrc"
fi

PROFILES="$PROFILE|.zshrc"
IFS='|'
for file in $(echo "$PROFILES"); do
  cat << EOF >> $HOME/$file

export BASH_PROFILE="\$HOME/$PROFILE"
export BASH_KIT_DIR="\$HOME/$BASH_KIT_DIR"

if [ -d "\$BASH_KIT_DIR" ]; then
  if [ "\$BASH" -o "\$ZSH" ]; then
    if [ -f "\$HOME/$BASH_KIT_DIR/profile" ]; then
      . "\$HOME/$BASH_KIT_DIR/profile"
    fi
  fi
fi

EOF
done
unset IFS

echo "\033[0;35mTo complete the installation run the following command:\nsource $HOME/$PROFILE\033[0m"

echo "\033[0;32mDone\033[0m"
