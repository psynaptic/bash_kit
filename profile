export BASH_KIT_DIR="$HOME/.bash_kit"
export BASH_PROFILE="$HOME/.profile"
export INPUTRC=$BASH_KIT_DIR/input
export REPO_SERVER="git@109.74.198.203"
export REPO_LOCATION=""
export CVSROOT=":pserver:$CVS_USER@cvs.drupal.org:/cvs/drupal-contrib"
export CVS_RSH="ssh"

# Import alias definitions
if [ -f $BASH_KIT_DIR/aliases ]; then
  . $BASH_KIT_DIR/aliases
fi

# Import custom alias definitions
if [ -f $BASH_KIT_DIR/.aliases_custom ]; then
  $HOME/.aliases_custom
fi

# Import function definitions
if [ -f $BASH_KIT_DIR/functions ]; then
  . $BASH_KIT_DIR/functions
fi

# Prompt to $host: /$pwd> in purple
PS1='\[\e[0;35m\]\h: ${PWD}\[\e[m\]\[\e[1;35m\]> \[\e[m\]\[\e '

# Make bash autocomplete with up arrow
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Make cd try only directories
complete -d cd
