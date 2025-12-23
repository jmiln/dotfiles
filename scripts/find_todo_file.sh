#!/usr/bin/env bash

# Config
EDITOR="nvim"
GLOBAL_TODO="$HOME/.todo.md"

# Get the current path from the pane we're in
PANE_PATH="$(tmux display-message -p -F "#{pane_current_path}")"

# See if there's a todo file in the current project's root dir
if PROJECT_ROOT="$(git -C "$PANE_PATH" rev-parse --show-toplevel 2>/dev/null)"; then
    PROJECT_TODO="$PROJECT_ROOT/TODO.md"
else
    PROJECT_TODO=""
fi

# Decide which todo to open
if [[ -n "$PROJECT_TODO" && -f "$PROJECT_TODO" ]]; then
    TODO_FILE="$PROJECT_TODO"
else
    TODO_FILE="$GLOBAL_TODO"
fi

# Create pane and open editor
tmux display-popup -E -w 80% -h 80% -x C -y C "$EDITOR $TODO_FILE"
