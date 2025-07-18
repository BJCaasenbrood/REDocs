#!/bin/bash

# Check if there are any .md files in the draft folder
if ! ls draft/*.md 1> /dev/null 2>&1; then
    echo "No Markdown files found in the draft folder. Skipping conversion."
else
    # Convert all .md files in the draft folder to .tex using pandoc
    for md_file in draft/*.md; do
        tex_file="${md_file%.md}.tex"
        echo "Converting $md_file to $tex_file..."
        pandoc "$md_file" -o "$tex_file" --metadata link-citations=true --sourcepos
        if [[ $? -ne 0 ]]; then
            echo "Error: Failed to convert $md_file to $tex_file."
            exit 1
        fi
    done
fi

# Define the input LaTeX file
INPUT_FILE="main.tex"

# Check if the file exists
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: File '$INPUT_FILE' not found!"
    exit 1
fi

# Run pdflatex to compile the file
echo "Compiling $INPUT_FILE..."
pdflatex -synctex=1 -interaction=nonstopmode "$INPUT_FILE" > compile.log

# Check if the compilation was successful
if grep -q "Fatal error" compile.log; then
    echo "Compilation failed. Check 'compile.log' for details."
    exit 1
else
    echo "Compilation successful! Output file: main.pdf"
fi

# Optional: Clean up temporary files created by pdflatex
read -p "Do you want to remove auxiliary files? (y/n): " response
if [[ "$response" == "y" || "$response" == "Y" ]]; then
    rm -f main.aux main.log main.toc
    echo "Auxiliary files removed."
fi

exit 0