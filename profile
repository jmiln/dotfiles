# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

set -o ignoreeof

if [ -d "$HOME/.zshrc" ]; then
    "$HOME/.zshrc"
elif [ -d "$HOME/.bashrc" ]; then
    "$HOME/.bashrc"
fi

if [ -n "$DISPLAY" ]; then
    BROWSER=chromium
fi

export EDITOR=vim
# export TERM=xterm-256color

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export TZ="America/Los_Angeles"
. "$HOME/.cargo/env"
