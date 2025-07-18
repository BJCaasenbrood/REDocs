#!/bin/bash

# REDocs Bibliography Management Script
# This script helps manage PDFs and generate bibliography entries

BIB_DIR="bib"
BIB_FILE="draft/references.bib"

# Create bib directory if it doesn't exist
mkdir -p "$BIB_DIR"

# Function to display help
show_help() {
    echo "REDocs Bibliography Management"
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  add <pdf_file>     - Add a PDF to the bibliography system"
    echo "  list               - List all PDFs in the bibliography"
    echo "  generate           - Generate/update the .bib file"
    echo "  help               - Show this help message"
    echo ""
    echo "Workflow:"
    echo "  1. Place PDF files in the root directory"
    echo "  2. Run: $0 add <filename.pdf>"
    echo "  3. The script will prompt for a meaningful name"
    echo "  4. The PDF will be moved to the bib/ folder"
    echo "  5. Run: $0 generate to update bibliography"
}

# Function to add a PDF
add_pdf() {
    local pdf_file="$1"
    
    if [[ ! -f "$pdf_file" ]]; then
        echo "Error: File '$pdf_file' not found!"
        return 1
    fi
    
    if [[ ! "$pdf_file" =~ \.pdf$ ]]; then
        echo "Error: '$pdf_file' is not a PDF file!"
        return 1
    fi
    
    echo "Adding PDF: $pdf_file"
    echo "Current filename: $(basename "$pdf_file")"
    echo ""
    
    # Prompt for new name
    read -p "Enter a meaningful name (without .pdf extension): " new_name
    
    if [[ -z "$new_name" ]]; then
        echo "Error: Name cannot be empty!"
        return 1
    fi
    
    # Clean the name (remove spaces, special characters)
    new_name=$(echo "$new_name" | tr ' ' '_' | tr -cd '[:alnum:]_-')
    new_filename="${new_name}.pdf"
    
    # Move to bib directory
    mv "$pdf_file" "$BIB_DIR/$new_filename"
    
    echo "PDF moved to: $BIB_DIR/$new_filename"
    echo "Remember to run '$0 generate' to update the bibliography!"
}

# Function to list PDFs
list_pdfs() {
    echo "PDFs in bibliography:"
    echo "===================="
    if [[ -d "$BIB_DIR" ]]; then
        find "$BIB_DIR" -name "*.pdf" -type f | sort
    else
        echo "No bibliography directory found."
    fi
}

# Function to generate bibliography
generate_bib() {
    echo "Generating bibliography entries..."
    echo "Note: This is a placeholder - you'll need to manually create .bib entries"
    echo "PDFs found in $BIB_DIR:"
    
    if [[ -d "$BIB_DIR" ]]; then
        for pdf in "$BIB_DIR"/*.pdf; do
            if [[ -f "$pdf" ]]; then
                basename_no_ext=$(basename "$pdf" .pdf)
                echo "  - $basename_no_ext"
                echo "    Add to $BIB_FILE:"
                echo "    @article{$basename_no_ext,"
                echo "      title={Title Here},"
                echo "      author={Author Here},"
                echo "      journal={Journal Here},"
                echo "      year={Year Here},"
                echo "      file={$pdf}"
                echo "    }"
                echo ""
            fi
        done
    fi
}

# Main script logic
case "$1" in
    "add")
        if [[ -z "$2" ]]; then
            echo "Error: Please specify a PDF file to add"
            echo "Usage: $0 add <pdf_file>"
            exit 1
        fi
        add_pdf "$2"
        ;;
    "list")
        list_pdfs
        ;;
    "generate")
        generate_bib
        ;;
    "help"|"--help"|"-h"|"")
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac