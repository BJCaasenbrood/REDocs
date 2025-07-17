#!/bin/bash

# Define the input LaTeX file
INPUT_FILE="main.tex"

# Check if the file exists
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: File '$INPUT_FILE' not found!"
    exit 1
fi

# Run pdflatex to compile the file
echo "Compiling $INPUT_FILE..."
xelatex -interaction=nonstopmode "$INPUT_FILE" > compile.log

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