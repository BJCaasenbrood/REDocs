#!/bin/bash

# Check if the "bib" folder exists
if [ ! -d "bib" ]; then
    echo "Error: 'bib' folder does not exist in the current directory."
    exit 1
fi

# Check if `code` command is available (VS Code CLI)
if ! command -v code &> /dev/null; then
    echo "Error: VS Code command ('code') is not installed or not in PATH."
    exit 1
fi

# List all PDF file names in the 'bib' directory as clickable links
echo "Listing all PDF files './bib' folder:"
for pdf in bib/*.pdf; do
    if [[ -e "$pdf" ]]; then
        # Generate a clickable hyperlink (using ANSI escape sequences)
        file_path=$(realpath "$pdf")
        echo -e "\033]8;;file://$file_path\033\\$(basename "$pdf")\033]8;;\033\\"
    fi
done