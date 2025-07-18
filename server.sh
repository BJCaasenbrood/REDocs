#!/bin/bash

# REDocs Auto-Compilation Server
# This script starts the automatic compilation watchdog that monitors
# for changes in markdown files and automatically compiles to PDF

echo "Starting REDocs auto-compilation server..."
echo "Watching for changes in ./draft/*.md files..."
echo "Press Ctrl+C to stop the server"
echo ""

# Start the Python watchdog compiler
python watchdog_compiler.py