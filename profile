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

# Import configuration for the active shell.

if [ "$BASH" ]; then
  if [ -f "$BASH_KIT_DIR/shells/bash" ]; then
    . "$BASH_KIT_DIR/shells/bash"
  fi
fi

if [ "$ZSH" ]; then
  if [ -f "$BASH_KIT_DIR/shells/zsh" ]; then
    . "$BASH_KIT_DIR/shells/zsh"
  fi
fi
