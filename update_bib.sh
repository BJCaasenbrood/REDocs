#!/bin/bash

BIB_DIR="bib"
mkdir -p "$BIB_DIR"

pdfs=$(find . -maxdepth 1 -type f -name "*.pdf" ! -name "main.pdf")
if [ -z "$pdfs" ]; then
    echo "No PDF files found to rename."
fi

pdfs=$(find . -maxdepth 1 -type f -name "*.pdf" ! -name "main.pdf")
if [ -z "$pdfs" ]; then
    echo "No PDF files found to rename."
    # exit 0
fi

find . -maxdepth 1 -type f -name "*.pdf" ! -name "main.pdf" -print0 | while read -d $'\0' pdf_file; do
    # Run pdfrenamer on the PDF
    if [ -n "$pdf_file" ]; then
        pdfrenamer "$pdf_file"
        if [ $? -eq 0 ]; then
            # Find the most recently modified PDF, excluding main.pdf
            renamed_file=$(ls -t *.pdf | grep -v "^main.pdf$" | head -n 1)
            if [ -n "$renamed_file" ] && [ -e "$renamed_file" ]; then
                mv "$renamed_file" "$BIB_DIR/"
                echo "Moved $renamed_file to $BIB_DIR"
            else
                echo "No renamed PDF found to move for $pdf_file"
            fi
        else
            echo "Failed to rename $pdf_file"
        fi
    fi
done

# Remove old references.bib if it exists
rm -f references.bib

if [ "$(ls -A $BIB_DIR/*.pdf 2>/dev/null)" ]; then
    echo "Busy generating references.bib from PDFs in $BIB_DIR..."
    
    # Create a temporary file to collect all bib entries
    temp_bib=$(mktemp)
    
    for pdf in $BIB_DIR/*.pdf; do
        echo "Processing $pdf..."
        pdf2bib "$pdf" >> "$temp_bib"
    done
    
    # Process the temporary file to remove duplicates and clean up
    if [ -f "$temp_bib" ]; then
        # Remove the verbose output lines and extract unique entries
        python3 -c "
import re
import sys

# Read the temp bib file
with open('$temp_bib', 'r') as f:
    content = f.read()

# Remove pdf2bib verbose output lines
content = re.sub(r'^\s*\(All intermediate output.*\n?', '', content, flags=re.MULTILINE)

# Extract all BibTeX entries
entries = re.findall(r'@\w+\s*\{[^@]*?\n\s*\}', content, re.DOTALL)

# Track seen bibkeys to avoid duplicates
seen_keys = set()
unique_entries = []

for entry in entries:
    # Extract the citation key
    key_match = re.search(r'@\w+\s*\{\s*([^,\s]+)', entry)
    if key_match:
        bibkey = key_match.group(1)
        if bibkey not in seen_keys:
            seen_keys.add(bibkey)
            unique_entries.append(entry.strip())
            print(f'Added: {bibkey}', file=sys.stderr)
        else:
            print(f'Skipped duplicate: {bibkey}', file=sys.stderr)

# Write unique entries to references.bib
with open('references.bib', 'w') as f:
    for entry in unique_entries:
        f.write(entry + '\n\n')

print(f'Generated references.bib with {len(unique_entries)} unique entries', file=sys.stderr)
"
        # Clean up temp file
        rm -f "$temp_bib"
        echo "Done creating references.bib with duplicate removal"
    else
        echo "Failed to create temporary bib file"
    fi
else
    echo "No PDFs found in $BIB_DIR to create .bib file."
fi

# Copy references.bib to the draft folder with a different name
DRAFT_DIR="draft"
if [ -f references.bib ]; then
    mkdir -p "$DRAFT_DIR"
    cp references.bib "$DRAFT_DIR/ref.bib"
    echo "Copied references.bib to $DRAFT_DIR/ref.bib"
fi