# REDocs - Research Document Compilation System

REDocs is an automated document compilation system that allows you to write research papers in Markdown format and automatically compiles them to LaTeX and PDF. The system provides automatic bibliography management and real-time compilation upon file changes.

## Overview

This repository contains a complete LaTeX document compilation workflow with the following key features:

- **Markdown to LaTeX conversion** using Pandoc
- **Automatic PDF compilation** using XeLaTeX 
- **Real-time file watching** for automatic recompilation
- **Bibliography management** with automatic .bib file generation
- **PDF reference management** system

## Repository Structure

```
REDocs/
├── assets/              # Generated PDF versions
├── draft/               # Main LaTeX project folder
│   ├── 0_abstract/      # Abstract section (markdown + tex)
│   ├── 1_introduction/  # Introduction section (markdown + tex)
│   ├── main.tex         # Main LaTeX document
│   ├── compile.sh       # LaTeX compilation script
│   └── *.bib           # Bibliography files
├── proposal/           # Alternative LaTeX project
├── bib/               # Bibliography management folder
├── make.sh            # Main compilation script
├── manage_bib.sh      # Bibliography management script
├── watchdog_compiler.py # Auto-compilation server
└── server.sh          # Auto-compilation server (alias)
```

## Quick Start

### 1. Prerequisites

Make sure you have the following installed:
- Python 3.x with `watchdog` package
- Pandoc for Markdown to LaTeX conversion
- XeLaTeX for PDF compilation
- BibTeX for bibliography management

```bash
# Install Python dependencies
pip install watchdog

# Install system dependencies (Ubuntu/Debian)
sudo apt-get install pandoc texlive-xetex texlive-bibtex-extra
```

### 2. Start the Auto-Compilation Server

To start the automatic compilation server that watches for changes:

```bash
# Option 1: Use the Python watchdog script
python watchdog_compiler.py

# Option 2: Use the server script (if available)
./server.sh
```

The server will watch for changes in `.md` files within the `draft/` folder and automatically:
1. Convert Markdown files to LaTeX using Pandoc
2. Compile the main LaTeX document to PDF
3. Move the generated PDF to the root directory

### 3. Writing Content

#### Adding New Sections

1. Create a new folder in `draft/` for your section (e.g., `2_methodology/`)
2. Create a Markdown file inside (e.g., `2_methodology.md`)
3. Add the section to your `main.tex` file:

```latex
\input{./2_methodology/2_methodology.tex}
```

#### Writing in Markdown

Write your content in Markdown format. The system supports:
- Standard Markdown syntax
- LaTeX math equations
- Citations (using BibTeX keys)
- Figures and tables

Example:
```markdown
# Methodology

This section describes our approach to **computational co-design**.

## Mathematical Framework

The optimization problem can be formulated as:

$$\min_{x} f(x) \text{ subject to } g(x) \leq 0$$

We cite the seminal work by @author2023 in this field.
```

## Bibliography Management

### Adding PDF References

To add new research papers to your bibliography:

1. **Add PDFs to the main folder**: Place your PDF files in the root directory
2. **Rename and organize**: The system will help you rename PDFs with meaningful names
3. **Move to bib folder**: PDFs are organized in the `bib/` folder
4. **Generate .bib entries**: The system automatically generates bibliography entries

### Manual Bibliography Process

1. Place PDF files in the root directory:
```bash
cp /path/to/your/paper.pdf ./
```

2. Rename the PDF with a meaningful name:
```bash
mv paper.pdf smith2023_computational_design.pdf
```

3. Move to the bib folder:
```bash
mkdir -p bib/
mv smith2023_computational_design.pdf bib/
```

4. Generate or update your `.bib` file:
```bash
# The system should automatically generate entries
# Or manually add to your .bib file in draft/
```

### Using Citations

In your Markdown files, use standard BibTeX citation syntax:
```markdown
Recent work in this area [@smith2023; @jones2022] has shown...
```

## Compilation Process

### Automatic Compilation

When the server is running (`python watchdog_compiler.py`), any changes to `.md` files will trigger:

1. **Markdown to LaTeX conversion** using Pandoc
2. **LaTeX compilation** using XeLaTeX
3. **PDF generation** moved to root as `main.pdf`

### Manual Compilation

You can also compile manually:

```bash
# Run the complete compilation process
./make.sh

# Or compile just the LaTeX (from draft/ folder)
cd draft/
./compile.sh main.tex
```

## Advanced Usage

### Customizing the Compilation

#### Modifying make.sh

The `make.sh` script handles the complete compilation process:
- Converts all `.md` files to `.tex` using Pandoc
- Compiles the main LaTeX document
- Moves the PDF to the root directory

#### Customizing the Watchdog

The `watchdog_compiler.py` script can be modified to:
- Watch different file types
- Change compilation behavior
- Add custom processing steps

### Working with Multiple Projects

The repository supports multiple LaTeX projects:
- `draft/` - Main research document
- `proposal/` - Research proposal
- Add your own project folders as needed

## Troubleshooting

### Common Issues

1. **Compilation fails**: Check `compile.log` in the draft folder
2. **Pandoc not found**: Ensure Pandoc is installed and in PATH
3. **XeLaTeX errors**: Check your LaTeX installation
4. **Watchdog not working**: Ensure Python watchdog package is installed

### Log Files

- `draft/compile.log` - LaTeX compilation logs
- Check console output from `watchdog_compiler.py` for real-time status

## File Permissions

Make sure the shell scripts are executable:
```bash
chmod +x make.sh
chmod +x draft/compile.sh
chmod +x server.sh  # if present
```

## Contributing

1. Add new sections by creating folders in `draft/`
2. Write content in Markdown format
3. Test compilation with `./make.sh`
4. The auto-compilation server will handle the rest

## License

This project is designed for academic research documentation and follows standard academic practices for document preparation and citation management.