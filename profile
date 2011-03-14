#!/bin/sh

# Import default configuration options
if [ -f "$BASH_KIT_DIR/options" ]; then
  . "$BASH_KIT_DIR/options"
fi

# Import alias definitions
if [ -f "$BASH_KIT_DIR/aliases" ]; then
  . "$BASH_KIT_DIR/aliases"
fi

# Import custom alias definitions
if [ -f "$BASH_KIT_ALIASES" ]; then
  . "$BASH_KIT_ALIASES"
fi

# Import function definitions
if [ -f "$BASH_KIT_DIR/functions" ]; then
  . "$BASH_KIT_DIR/functions"
fi

# Import Version Control System agnostic commands
if [ -f "$BASH_KIT_DIR/vc" ]; then
  . "$BASH_KIT_DIR/vc"
fi

# Import colour definitions
if [ -f "$BASH_KIT_DIR/colours" ]; then
  . "$BASH_KIT_DIR/colours"
fi

# Command prompt
PS1="\[$text_blue\]\u@\h: \w\[$reset\]\[$bold_blue\]>\[$reset\] "

# Make bash autocomplete with up arrow
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Make cd try only directories
complete -d cd
