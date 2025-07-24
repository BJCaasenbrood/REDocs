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
    echo "First compilation failed. Check 'compile.log' for details."
    exit 1
else
    echo "First compilation successful!"
fi

# Check if we have a bibliography file and run bibtex
if [[ -f "references.bib" ]] || [[ -f "ref.bib" ]]; then
    echo "Running bibtex..."
    bibtex main >> compile.log 2>&1
    
    if [[ $? -eq 0 ]]; then
        echo "Bibtex compilation successful!"
        
        # Run pdflatex again to include bibliography
        echo "Running second pdflatex to include bibliography..."
        pdflatex -synctex=1 -interaction=nonstopmode "$INPUT_FILE" >> compile.log 2>&1
        
        # Run pdflatex one more time to resolve all references
        echo "Running final pdflatex to resolve all references..."
        pdflatex -synctex=1 -interaction=nonstopmode "$INPUT_FILE" >> compile.log 2>&1
        
        if [[ $? -eq 0 ]]; then
            echo "Final compilation successful! Output file: main.pdf"
        else
            echo "Final compilation failed. Check 'compile.log' for details."
            exit 1
        fi
    else
        echo "Bibtex failed. Check 'compile.log' for details."
        echo "Continuing without bibliography..."
    fi
else
    echo "No bibliography file found (references.bib or ref.bib). Skipping bibtex."
    echo "Compilation successful! Output file: main.pdf"
fi

# Optional: Clean up temporary files created by pdflatex
read -p "Do you want to remove auxiliary files? (y/n): " response
if [[ "$response" == "y" || "$response" == "Y" ]]; then
    rm -f main.aux main.log main.toc main.bbl main.blg main.out main.fls main.fdb_latexmk main.synctex.gz
    echo "Auxiliary files removed."
fi

exit 0