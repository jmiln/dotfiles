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

# If in a Git repo, check for a root TODO
if PROJECT_ROOT="$(git -C "$PANE_PATH" rev-parse --show-toplevel 2>/dev/null)"; then
    PROJECT_NAME="${PROJECT_ROOT##*/}"
    PROJECT_TODO=$(find "$PROJECT_ROOT" -maxdepth 1 -iname "todo.md" -o -iname "todo.txt" | head -n 1)

    if [[ -n "$PROJECT_TODO" ]]; then
        TODO_FILE="$PROJECT_TODO"
        LABEL=" Project: $PROJECT_NAME "
    else
        # If in a git repo but no project todo file exists yet, still use Global
        LABEL=" Global (in $PROJECT_NAME) "
    fi
fi

# If it's still set to the global todo, check for a local todo
if [[ "$TODO_FILE" == "$GLOBAL_TODO" ]]; then
    LOCAL_SEARCH=$(find "$PANE_PATH" -maxdepth 1 -iname "todo.md" -o -iname "todo.txt" | head -n 1)

    if [[ -n "$LOCAL_SEARCH" ]]; then
        TODO_FILE="$LOCAL_SEARCH"
        LABEL=" Local: ${PANE_PATH##*/} "
    fi
fi

# Create pane and open editor
tmux display-popup -E -w 95% -h 95% -d "$PANE_PATH" \
    -b rounded \
    -T "#[fg=orange,bold]$LABEL#[default]" \
    "$EDITOR $TODO_FILE"
