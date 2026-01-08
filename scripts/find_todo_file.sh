#!/usr/bin/env bash
set -euo pipefail

# Config
GLOBAL_TODO="$HOME/.todo.md"
[[ -f "$GLOBAL_TODO" ]] || touch "$GLOBAL_TODO"

# Get the current path from the pane we're in
PANE_PATH="$(tmux display-message -p -F "#{pane_current_path}")"

# Default to the global todo
TODO_FILE="$GLOBAL_TODO"
LABEL=" Global Todo "

if PROJECT_ROOT="$(git -C "$PANE_PATH" rev-parse --show-toplevel 2>/dev/null)"; then
    # Grab just the directory name of the project
    PROJECT_NAME="${PROJECT_ROOT##*/}"

    # Look for existing project todo
    FIND_PROJECT_TODO=$(find "$PROJECT_ROOT" -maxdepth 1 -iname "todo.md" -o -iname "todo.txt" | head -n 1)

    if [[ -n "$FIND_PROJECT_TODO" ]]; then
        TODO_FILE="$FIND_PROJECT_TODO"
        LABEL=" Project: $PROJECT_NAME "
    else
        # If in a git repo but no project todo file exists yet, still use Global
        TODO_FILE="$GLOBAL_TODO"
        LABEL=" Global (in $PROJECT_NAME) "
    fi
fi

# Create pane and open editor
# tmux display-popup -E -w 80% -h 80% -x C -y C "$EDITOR $TODO_FILE"
tmux display-popup -E -w 85% -h 85% -d "$PANE_PATH" \
    -b rounded \
    -T "#[fg=orange,bold]$LABEL#[default]" \
    "$EDITOR $TODO_FILE"
