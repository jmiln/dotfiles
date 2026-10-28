# Only bash and sh login shells read this; zsh uses ~/.zshenv instead

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

set -o ignoreeof

if [ -n "$DISPLAY" ]; then
    BROWSER=chromium
fi

export EDITOR=vim

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Login shells skip ~/.bashrc unless it's sourced here
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
