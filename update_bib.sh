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
    for pdf in $BIB_DIR/*.pdf; do
        pdf2bib "$pdf" >> references.bib
    done
    echo "Done creating references.bib"
else
    echo "No PDFs found in $BIB_DIR to create .bib file."
fi