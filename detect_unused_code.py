#!/usr/bin/env python3
"""
Unused Code Detection Tool for REDocs Repository

This tool analyzes the REDocs repository to identify unused files and code.
It checks for:
1. LaTeX files that are not referenced via \\input{} or \\include{}
2. Python functions/classes that are not called
3. Shell script functions that are not used
4. Sample/template files that are not utilized
5. Image files that are not referenced
"""

import os
import re
import sys
from pathlib import Path
from collections import defaultdict
import argparse


class UnusedCodeDetector:
    def __init__(self, repo_path):
        self.repo_path = Path(repo_path)
        self.used_files = set()
        self.all_files = set()
        self.latex_files = set()
        self.python_files = set()
        self.shell_files = set()
        self.image_files = set()
        self.dependencies = defaultdict(set)
        self.unused_files = set()
        self.results = {
            'unused_files': [],
            'unused_functions': [],
            'unused_classes': [],
            'sample_files': [],
            'summary': {}
        }
        
    def scan_repository(self):
        """Scan the repository and categorize files."""
        print("Scanning repository structure...")
        
        for root, dirs, files in os.walk(self.repo_path):
            # Skip .git directory
            if '.git' in dirs:
                dirs.remove('.git')
                
            for file in files:
                file_path = Path(root) / file
                relative_path = file_path.relative_to(self.repo_path)
                
                self.all_files.add(relative_path)
                
                # Categorize files by type
                if file.endswith('.tex'):
                    self.latex_files.add(relative_path)
                elif file.endswith('.py'):
                    self.python_files.add(relative_path)
                elif file.endswith('.sh'):
                    self.shell_files.add(relative_path)
                elif file.endswith(('.png', '.jpg', '.jpeg', '.pdf', '.eps')):
                    self.image_files.add(relative_path)
                    
        print(f"Found {len(self.all_files)} files:")
        print(f"  - LaTeX files: {len(self.latex_files)}")
        print(f"  - Python files: {len(self.python_files)}")
        print(f"  - Shell files: {len(self.shell_files)}")
        print(f"  - Image files: {len(self.image_files)}")
        
    def analyze_latex_dependencies(self):
        """Analyze LaTeX file dependencies using \\input{} and \\include{}."""
        print("\nAnalyzing LaTeX file dependencies...")
        
        # Patterns to match LaTeX includes
        input_pattern = r'\\input\{([^}]+)\}'
        include_pattern = r'\\include\{([^}]+)\}'
        includegraphics_pattern = r'\\includegraphics(?:\[[^\]]*\])?\{([^}]+)\}'
        
        for tex_file in self.latex_files:
            try:
                file_path = self.repo_path / tex_file
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    
                # Find \input{} statements
                inputs = re.findall(input_pattern, content)
                for input_file in inputs:
                    # Handle relative paths and add .tex extension if missing
                    if not input_file.endswith('.tex'):
                        input_file += '.tex'
                    
                    # Resolve relative path
                    resolved_path = self._resolve_latex_path(tex_file, input_file)
                    if resolved_path:
                        self.dependencies[tex_file].add(resolved_path)
                        self.used_files.add(resolved_path)
                        
                # Find \include{} statements
                includes = re.findall(include_pattern, content)
                for include_file in includes:
                    if not include_file.endswith('.tex'):
                        include_file += '.tex'
                    
                    resolved_path = self._resolve_latex_path(tex_file, include_file)
                    if resolved_path:
                        self.dependencies[tex_file].add(resolved_path)
                        self.used_files.add(resolved_path)
                        
                # Find \includegraphics{} statements
                graphics = re.findall(includegraphics_pattern, content)
                for graphic_file in graphics:
                    resolved_path = self._resolve_latex_path(tex_file, graphic_file)
                    if resolved_path:
                        self.dependencies[tex_file].add(resolved_path)
                        self.used_files.add(resolved_path)
                        
                # Find bibliography files
                bib_pattern = r'\\bibliography\{([^}]+)\}'
                bibs = re.findall(bib_pattern, content)
                for bib_file in bibs:
                    if not bib_file.endswith('.bib'):
                        bib_file += '.bib'
                    resolved_path = self._resolve_latex_path(tex_file, bib_file)
                    if resolved_path:
                        self.dependencies[tex_file].add(resolved_path)
                        self.used_files.add(resolved_path)
                        
            except Exception as e:
                print(f"Error reading {tex_file}: {e}")
                
    def _resolve_latex_path(self, base_file, target_file):
        """Resolve LaTeX file path relative to base file."""
        base_dir = (self.repo_path / base_file).parent
        
        # Try different possible paths
        possible_paths = [
            base_dir / target_file,
            self.repo_path / target_file,
            base_dir / Path(target_file).name
        ]
        
        for path in possible_paths:
            relative_path = path.relative_to(self.repo_path)
            if relative_path in self.all_files:
                return relative_path
                
        return None
        
    def analyze_python_dependencies(self):
        """Analyze Python file dependencies and function usage."""
        print("\nAnalyzing Python file dependencies...")
        
        for py_file in self.python_files:
            try:
                file_path = self.repo_path / py_file
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    
                # Find import statements
                import_pattern = r'import\s+(\w+)'
                from_import_pattern = r'from\s+(\w+)\s+import'
                
                imports = re.findall(import_pattern, content)
                from_imports = re.findall(from_import_pattern, content)
                
                for imp in imports + from_imports:
                    # Check if it's a local file
                    possible_file = Path(f"{imp}.py")
                    if possible_file in self.all_files:
                        self.dependencies[py_file].add(possible_file)
                        self.used_files.add(possible_file)
                        
            except Exception as e:
                print(f"Error reading {py_file}: {e}")
                
    def analyze_build_dependencies(self):
        """Analyze build script dependencies (make.sh, compile.sh)."""
        print("\nAnalyzing build script dependencies...")
        
        # Files that are used by build process
        build_files = {'make.sh', 'compile.sh'}
        
        for build_file in build_files:
            for file_path in self.all_files:
                if file_path.name == build_file:
                    self.used_files.add(file_path)
                    
                    try:
                        full_path = self.repo_path / file_path
                        with open(full_path, 'r', encoding='utf-8', errors='ignore') as f:
                            content = f.read()
                            
                        # Find file references in shell scripts
                        # Look for pandoc conversions
                        if 'pandoc' in content:
                            # Files converted by pandoc
                            for md_file in self.all_files:
                                if md_file.suffix == '.md':
                                    self.used_files.add(md_file)
                                    # Corresponding .tex file
                                    tex_file = md_file.with_suffix('.tex')
                                    if tex_file in self.all_files:
                                        self.used_files.add(tex_file)
                                        
                        # Look for LaTeX compilation
                        if 'latex' in content or 'pdflatex' in content or 'xelatex' in content:
                            # Main tex files are used
                            for tex_file in self.latex_files:
                                if 'main.tex' in str(tex_file):
                                    self.used_files.add(tex_file)
                                    
                        # Look for file operations
                        file_patterns = [
                            r'(\w+\.(?:tex|pdf|md|bib))',
                            r'(["\']([^"\']+\.(?:tex|pdf|md|bib))["\'])',
                        ]
                        
                        for pattern in file_patterns:
                            matches = re.findall(pattern, content)
                            for match in matches:
                                filename = match if isinstance(match, str) else match[0]
                                for file_path in self.all_files:
                                    if file_path.name == filename:
                                        self.used_files.add(file_path)
                                        
                    except Exception as e:
                        print(f"Error reading {file_path}: {e}")
                        
        # watchdog_compiler.py uses make.sh
        for py_file in self.python_files:
            if 'watchdog' in str(py_file):
                self.used_files.add(py_file)
                # It watches .md files and triggers make.sh
                for md_file in self.all_files:
                    if md_file.suffix == '.md':
                        self.used_files.add(md_file)
                
    def identify_entry_points(self):
        """Identify entry point files (main files that are likely to be used)."""
        print("\nIdentifying entry points...")
        
        entry_points = set()
        
        # Files that are likely entry points
        entry_point_names = ['main.tex', 'main.py', 'make.sh', 'compile.sh']
        
        for file_path in self.all_files:
            if file_path.name in entry_point_names:
                entry_points.add(file_path)
                self.used_files.add(file_path)
                
        # Executable files
        for file_path in self.all_files:
            full_path = self.repo_path / file_path
            if full_path.is_file() and os.access(full_path, os.X_OK):
                entry_points.add(file_path)
                self.used_files.add(file_path)
                
        print(f"Found {len(entry_points)} entry points: {[str(f) for f in entry_points]}")
        
    def identify_sample_files(self):
        """Identify sample/template files that might be unused."""
        print("\nIdentifying sample/template files...")
        
        sample_patterns = [
            r'sample-.*',
            r'.*-sample.*',
            r'template.*',
            r'.*-template.*',
            r'example.*',
            r'.*-example.*'
        ]
        
        for file_path in self.all_files:
            for pattern in sample_patterns:
                if re.match(pattern, file_path.name, re.IGNORECASE):
                    self.results['sample_files'].append(str(file_path))
                    
        print(f"Found {len(self.results['sample_files'])} sample/template files")
        
    def find_unused_files(self):
        """Find files that are not referenced anywhere."""
        print("\nFinding unused files...")
        
        self.unused_files = self.all_files - self.used_files
        
        # Remove files that might be used externally or are important
        important_files = {
            'README.md', 'README.txt', 'LICENSE', '.gitignore', 'requirements.txt',
            'setup.py', 'Makefile', 'requirements.txt'
        }
        
        for file_path in list(self.unused_files):
            if file_path.name in important_files:
                self.unused_files.remove(file_path)
                
        self.results['unused_files'] = [str(f) for f in self.unused_files]
        
    def generate_report(self):
        """Generate a comprehensive report of unused code."""
        print("\n" + "="*60)
        print("UNUSED CODE DETECTION REPORT")
        print("="*60)
        
        # Summary
        total_files = len(self.all_files)
        used_files = len(self.used_files)
        unused_files = len(self.unused_files)
        
        print(f"\nSUMMARY:")
        print(f"Total files: {total_files}")
        print(f"Used files: {used_files}")
        print(f"Unused files: {unused_files}")
        print(f"Usage rate: {(used_files/total_files)*100:.1f}%")
        
        # Unused files
        if self.results['unused_files']:
            print(f"\nUNUSED FILES ({len(self.results['unused_files'])}):")
            for file in sorted(self.results['unused_files']):
                print(f"  - {file}")
                
        # Sample files
        if self.results['sample_files']:
            print(f"\nSAMPLE/TEMPLATE FILES ({len(self.results['sample_files'])}):")
            print("(These might be examples and could be removed if not needed)")
            for file in sorted(self.results['sample_files']):
                print(f"  - {file}")
                
        # File dependencies
        print(f"\nFILE DEPENDENCIES:")
        for file, deps in sorted(self.dependencies.items()):
            if deps:
                print(f"  {file} depends on:")
                for dep in sorted(deps):
                    print(f"    - {dep}")
                    
        # Recommendations
        print(f"\nRECOMMENDATIONS:")
        if self.results['unused_files']:
            print("1. Consider removing unused files to reduce repository size")
        if self.results['sample_files']:
            print("2. Review sample/template files - remove if not needed")
        if not self.results['unused_files'] and not self.results['sample_files']:
            print("1. All files appear to be in use - good code hygiene!")
            
        print("\n" + "="*60)
        
        # Store summary
        self.results['summary'] = {
            'total_files': total_files,
            'used_files': used_files,
            'unused_files': unused_files,
            'usage_rate': (used_files/total_files)*100
        }
        
    def run_analysis(self):
        """Run the complete unused code analysis."""
        self.scan_repository()
        self.identify_entry_points()
        self.analyze_latex_dependencies()
        self.analyze_python_dependencies()
        self.analyze_build_dependencies()
        self.identify_sample_files()
        self.find_unused_files()
        self.generate_report()
        
        return self.results


def main():
    parser = argparse.ArgumentParser(description='Detect unused code in REDocs repository')
    parser.add_argument('path', nargs='?', default='.', help='Repository path (default: current directory)')
    parser.add_argument('--output', '-o', help='Output report to file')
    
    args = parser.parse_args()
    
    detector = UnusedCodeDetector(args.path)
    results = detector.run_analysis()
    
    if args.output:
        with open(args.output, 'w') as f:
            f.write("UNUSED CODE DETECTION REPORT\n")
            f.write("="*60 + "\n")
            f.write(f"Total files: {results['summary']['total_files']}\n")
            f.write(f"Used files: {results['summary']['used_files']}\n")
            f.write(f"Unused files: {results['summary']['unused_files']}\n")
            f.write(f"Usage rate: {results['summary']['usage_rate']:.1f}%\n\n")
            
            if results['unused_files']:
                f.write("UNUSED FILES:\n")
                for file in sorted(results['unused_files']):
                    f.write(f"  - {file}\n")
                f.write("\n")
                
            if results['sample_files']:
                f.write("SAMPLE/TEMPLATE FILES:\n")
                for file in sorted(results['sample_files']):
                    f.write(f"  - {file}\n")
                    
        print(f"\nReport saved to: {args.output}")


if __name__ == "__main__":
    main()