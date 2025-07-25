# Unused Code Detection Tool

This tool helps identify unused files and code in the REDocs repository to maintain a clean codebase and reduce repository size.

## Features

- **LaTeX Dependency Analysis**: Detects files referenced via `\input{}`, `\include{}`, and `\includegraphics{}`
- **Build Script Analysis**: Identifies files used by make.sh and compile.sh scripts
- **Sample File Detection**: Finds template/example files that might be unnecessary
- **Python/Shell Dependency Tracking**: Analyzes import statements and script calls
- **Comprehensive Reporting**: Generates detailed reports with recommendations

## Usage

### Basic Usage

```bash
python3 detect_unused_code.py
```

### Generate Report File

```bash
python3 detect_unused_code.py --output unused_code_report.txt
```

### Run Tests

```bash
python3 test_unused_code_detection.py
```

## What It Detects

### Used Files
- Main LaTeX documents (main.tex files)
- Files referenced in `\input{}` and `\include{}` statements
- Images referenced in `\includegraphics{}` statements
- Bibliography files referenced in `\bibliography{}` statements
- Files processed by build scripts (make.sh, compile.sh)
- Markdown files converted by pandoc
- Python modules imported in scripts
- Shell scripts called by other scripts

### Unused Files
- LaTeX files not referenced anywhere
- Orphaned image files
- Template/sample files that serve as examples
- Build artifacts and temporary files
- Old backup files (main2.pdf, main3.pdf, etc.)

### Sample/Template Files
Files matching patterns like:
- `sample-*`
- `template-*`
- `example-*`
- `*-sample`
- `*-template`
- `*-example`

## Current Analysis Results

Based on the latest analysis of the REDocs repository:

- **Total files**: 63
- **Used files**: 19 (30.2% usage rate)
- **Unused files**: 41
- **Sample files**: 8

### Major Unused Categories

1. **ACM Template Files**: Many unused ACM LaTeX class files and examples
2. **Sample Documents**: Multiple sample-sigconf-*.tex files
3. **Build Artifacts**: Compilation logs and temporary files
4. **Old PDFs**: Multiple versions of main.pdf in assets/
5. **Empty Files**: proposal/paper.tex appears to be empty

### Recommendations

1. **Remove Sample Files**: The 8 sample files take up significant space and are likely not needed
2. **Clean Build Artifacts**: Remove .log, .out, and other temporary files
3. **Archive Old PDFs**: Move old PDF versions to a separate archive if needed
4. **Remove Empty Files**: Delete proposal/paper.tex if it's not being used

## Integration

The tool can be integrated into the development workflow:

1. **Pre-commit Hook**: Run analysis before commits to prevent unused code accumulation
2. **CI/CD Pipeline**: Include in continuous integration to monitor code cleanliness
3. **Regular Maintenance**: Schedule periodic runs to identify and remove unused files

## Limitations

- May not detect dynamic file references (e.g., programmatically generated filenames)
- Doesn't analyze content of included packages or classes
- May flag files as unused if they're only referenced in comments
- Doesn't track usage outside the repository

## Files Created

- `detect_unused_code.py` - Main detection tool
- `test_unused_code_detection.py` - Test suite
- `unused_code_report.txt` - Generated report file
- `README_unused_code_detection.md` - This documentation