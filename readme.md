#Bash Kit

Bash kit is a collection of shell functions, scripts, and aliases to make working in the shell easier.

##Installation

###Automatic

    wget --no-check-certificate https://raw.githubusercontent.com/psynaptic/bash_kit/master/install.sh -O - | sh

###Manual

Clone or otherwise download bash kit to your machine.

    git clone git://github.com/psynaptic/bash_kit.git ~/.kit

####Append variables to your bash profile

NOTE: This is handled by the installer so you only need to do this if installing manually.

Append the import code to your shell profile file (e.g. .profile, .bash_profile, .zshrc):

    # Import bash_kit for bash and zsh login shells.
    export BASH_KIT_DIR="$HOME/.kit"
    if [ -d "$BASH_KIT_DIR" ]; then
      if [ "$BASH" -o "$ZSH" ]; then
        if [ -f "$HOME/.kit/profile" ]; then
          . "$HOME/.kit/profile"
        fi
      fi
    fi

Source your shell profile, for example:

    source ~/.bash_profile

##Usage

For now, please see the inline documentation for each feature.
