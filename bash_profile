export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="/home/sean/.local/bin:$PATH"
export PATH="/home/sean/.emacs.d/bin:$PATH"
export PATH="/snap/bin/:$PATH"
export PATH="/usr/local/go/bin:$PATH"


# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi
