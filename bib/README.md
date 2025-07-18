# Bibliography Management

This folder contains PDF files that are managed by the REDocs bibliography system.

## Adding PDFs

Use the `manage_bib.sh` script to add new PDF files to the bibliography:

```bash
# Add a PDF file from the root directory
./manage_bib.sh add your_paper.pdf

# List all PDFs in the bibliography
./manage_bib.sh list

# Generate bibliography entries
./manage_bib.sh generate
```

## Organization

PDFs are stored here with meaningful names that correspond to their citation keys. For example:
- `smith2023_computational_design.pdf`
- `jones2022_mechatronics.pdf`

## Bibliography Integration

After adding PDFs to this folder, remember to:
1. Run `./manage_bib.sh generate` to get template .bib entries
2. Copy the suggested entries to your `.bib` file in the `draft/` folder
3. Cite the papers in your Markdown files using `[@smith2023]` syntax