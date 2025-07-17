#!/bin/bash

# Convert all .md files in proposal and subfolders to .tex using pandoc
cd draft
find . -type f -name "*.md" | while read mdfile; do
    texfile="${mdfile%.md}.tex"
    pandoc "$mdfile" -o "$texfile"
    echo "Converted $mdfile to $texfile using pandoc."
done

# Compile main.tex in the proposal folder using compile.sh
echo "y" | ./compile.sh main.tex

# Move the generated main.pdf to the parent directory
mv main.pdf ../

# Return to the original directory
cd ..

echo "main.pdf has been moved to $(pwd)"