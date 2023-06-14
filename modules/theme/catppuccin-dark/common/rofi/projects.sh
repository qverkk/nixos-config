#!/usr/bin/env bash

# Check if no input directories are provided
for arg in "$@"; do
    if [ "${#arg}" -gt 1 ]; then
        coproc kitty {
            kitty nvim "$@" > /dev/null 2>&1
        }
        exit 1
    fi
done

# Define the list of directories
directories=(
    "$HOME/Documents"
    "$HOME/Downloads"
    "$HOME/Documents/dev"
)

# Set case-insensitive matching for directory names
shopt -s nocaseglob

# Loop through each directory
for dir in "${directories[@]}"; do
    # Check if the directory exists
    if [ -d "$dir" ]; then
        # Find .git folders within two levels of the directory
        git_dirs=$(find "$dir" -maxdepth 2 -type d -name ".git")

        # Loop through the .git folders found
        while IFS= read -r git_dir; do
            # Extract the parent directory path
            parent_dir=$(dirname "$git_dir")
            echo "$parent_dir"
        done <<< "$git_dirs"
    else
        echo "Directory not found: $dir"
    fi
done

# Reset case sensitivity
shopt -u nocaseglob
