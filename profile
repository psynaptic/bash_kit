#!/bin/sh
export INPUTRC=$BASH_KIT_DIR/input
export CVSROOT=":pserver:$CVS_USER@cvs.drupal.org:/cvs/drupal-contrib"
export CVS_RSH="ssh"

# Import alias definitions
if [ -f $BASH_KIT_DIR/aliases ]; then
  . $BASH_KIT_DIR/aliases
fi

# Import custom alias definitions
if [ -f $HOME/.bash_aliases ]; then
  . $HOME/.bash_aliases
fi

# Import function definitions
if [ -f $BASH_KIT_DIR/functions ]; then
  . $BASH_KIT_DIR/functions
fi

if [ -f $BASH_KIT_DIR/colours ]; then
  . $BASH_KIT_DIR/colours
fi

# Prompt to $host: /$pwd> in purple
PS1="\[$txtpur\]\u@\h: ${PWD}\[$txtrst\]\[$bldpur\]>\[$txtrst\] "

# Make bash autocomplete with up arrow
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Make cd try only directories
complete -d cd
