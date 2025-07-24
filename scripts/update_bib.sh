#!/bin/bash

# Change to the parent directory (REDocs root)
cd "$(dirname "$0")/.."

BIB_DIR="draft/bib"
CACHE_DIR=".bib_cache"
CACHE_FILE="$CACHE_DIR/processed_files.txt"
TEMP_CACHE="$CACHE_DIR/temp_processed.txt"

mkdir -p "$BIB_DIR"
mkdir -p "$CACHE_DIR"

# Function to get file hash
get_file_hash() {
    if command -v md5sum >/dev/null 2>&1; then
        md5sum "$1" | cut -d' ' -f1
    elif command -v shasum >/dev/null 2>&1; then
        shasum "$1" | cut -d' ' -f1
    else
        # Fallback to modification time if no hash available
        stat -c %Y "$1" 2>/dev/null || stat -f %m "$1" 2>/dev/null || echo "0"
    fi
}

# Load previous cache if exists
declare -A processed_files
if [ -f "$CACHE_FILE" ]; then
    while IFS='|' read -r filename hash; do
        processed_files["$filename"]="$hash"
    done < "$CACHE_FILE"
fi

echo "🔍 Checking for new or changed PDF files..."

# Find PDFs that need processing
new_or_changed_pdfs=()
pdfs=$(find . -maxdepth 1 -type f -name "*.pdf" ! -name "main.pdf")

if [ -z "$pdfs" ]; then
    echo "No PDF files found to process."
else
    for pdf_file in $pdfs; do
        current_hash=$(get_file_hash "$pdf_file")
        filename=$(basename "$pdf_file")
        
        if [ "${processed_files[$filename]:-}" != "$current_hash" ]; then
            new_or_changed_pdfs+=("$pdf_file")
            echo "📄 Found changed/new file: $filename"
        fi
    done
fi

# Process only new or changed PDFs
if [ ${#new_or_changed_pdfs[@]} -eq 0 ]; then
    echo "✅ No new or changed PDF files found. Skipping processing."
else
    echo "🔄 Processing ${#new_or_changed_pdfs[@]} changed/new PDF files..."
    
    for pdf_file in "${new_or_changed_pdfs[@]}"; do
        if [ -n "$pdf_file" ]; then
            echo "Processing $pdf_file..."
            pdfrenamer "$pdf_file"
            if [ $? -eq 0 ]; then
                # Find the most recently modified PDF, excluding main.pdf
                renamed_file=$(ls -t *.pdf | grep -v "^main.pdf$" | head -n 1)
                if [ -n "$renamed_file" ] && [ -e "$renamed_file" ]; then
                    mv "$renamed_file" "$BIB_DIR/"
                    echo "Moved $renamed_file to $BIB_DIR"
                    
                    # Update cache with new hash
                    new_hash=$(get_file_hash "$BIB_DIR/$renamed_file")
                    processed_files["$(basename "$pdf_file")"]="$new_hash"
                else
                    echo "No renamed PDF found to move for $pdf_file"
                fi
            else
                echo "Failed to rename $pdf_file"
            fi
        fi
    done
fi

# Check if we need to regenerate bibliography
NEED_BIB_UPDATE=false

# Check if any PDFs were processed
if [ ${#new_or_changed_pdfs[@]} -gt 0 ]; then
    NEED_BIB_UPDATE=true
    echo "📚 Bibliography update needed due to new/changed PDFs"
fi

# Check if bibliography file is missing
if [ ! -f "draft/references.bib" ]; then
    NEED_BIB_UPDATE=true
    echo "📚 Bibliography update needed (references.bib missing)"
fi

# Check if any PDF files in bib directory are newer than references.bib
if [ -f "draft/references.bib" ] && [ "$(ls -A $BIB_DIR/*.pdf 2>/dev/null)" ]; then
    for pdf in $BIB_DIR/*.pdf; do
        if [ "$pdf" -nt "draft/references.bib" ]; then
            NEED_BIB_UPDATE=true
            echo "📚 Bibliography update needed ($(basename "$pdf") is newer)"
            break
        fi
    done
fi

# Only regenerate bibliography if needed
if [ "$NEED_BIB_UPDATE" = true ]; then
    echo "🔄 Updating bibliography..."
    
    # Remove old references.bib
    rm -f draft/references.bib

    if [ "$(ls -A $BIB_DIR/*.pdf 2>/dev/null)" ]; then
        echo "Generating references.bib from PDFs in $BIB_DIR..."
        
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
with open('draft/references.bib', 'w') as f:
    for entry in unique_entries:
        f.write(entry + '\n\n')

print(f'Generated draft/references.bib with {len(unique_entries)} unique entries', file=sys.stderr)
"
            # Clean up temp file
            rm -f "$temp_bib"
            echo "✅ Done creating draft/references.bib with duplicate removal"
        else
            echo "❌ Failed to create temporary bib file"
        fi
    else
        echo "No PDFs found in $BIB_DIR to create .bib file."
    fi
else
    echo "✅ Bibliography is up to date, skipping regeneration"
fi

# Update cache file with all processed files
> "$TEMP_CACHE"
for filename in "${!processed_files[@]}"; do
    echo "$filename|${processed_files[$filename]}" >> "$TEMP_CACHE"
done
mv "$TEMP_CACHE" "$CACHE_FILE"

echo "🎉 Update complete!"
