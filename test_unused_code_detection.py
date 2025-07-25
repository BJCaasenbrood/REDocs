#!/usr/bin/env python3
"""
Simple test script to validate the unused code detection tool.
"""

import os
import tempfile
import shutil
from pathlib import Path
from detect_unused_code import UnusedCodeDetector


def test_basic_functionality():
    """Test basic functionality of the unused code detector."""
    # Create a temporary directory structure
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        
        # Create test files
        (temp_path / "main.tex").write_text(r"""
\documentclass{article}
\begin{document}
\input{chapter1.tex}
\includegraphics{image1.png}
\end{document}
""")
        
        (temp_path / "chapter1.tex").write_text(r"""
\section{Chapter 1}
This is chapter 1.
""")
        
        (temp_path / "unused.tex").write_text(r"""
\section{Unused}
This file is not used.
""")
        
        (temp_path / "image1.png").write_text("fake image")
        (temp_path / "unused_image.png").write_text("unused image")
        
        # Run detector
        detector = UnusedCodeDetector(temp_path)
        results = detector.run_analysis()
        
        # Check results
        assert "unused.tex" in results['unused_files']
        assert "unused_image.png" in results['unused_files']
        assert "main.tex" not in results['unused_files']
        assert "chapter1.tex" not in results['unused_files']
        assert "image1.png" not in results['unused_files']
        
        print("✓ Basic functionality test passed")


def test_sample_file_detection():
    """Test detection of sample/template files."""
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        
        # Create sample files
        (temp_path / "sample-document.tex").write_text("Sample document")
        (temp_path / "template-file.tex").write_text("Template file")
        (temp_path / "example-usage.tex").write_text("Example usage")
        (temp_path / "normal-file.tex").write_text("Normal file")
        
        # Run detector
        detector = UnusedCodeDetector(temp_path)
        results = detector.run_analysis()
        
        # Check sample file detection
        assert "sample-document.tex" in results['sample_files']
        assert "template-file.tex" in results['sample_files']
        assert "example-usage.tex" in results['sample_files']
        assert "normal-file.tex" not in results['sample_files']
        
        print("✓ Sample file detection test passed")


def test_real_repository():
    """Test on the actual REDocs repository."""
    current_dir = Path(__file__).parent
    
    detector = UnusedCodeDetector(current_dir)
    results = detector.run_analysis()
    
    # Basic sanity checks
    assert len(results['unused_files']) > 0
    assert len(results['sample_files']) > 0
    assert results['summary']['total_files'] > 0
    assert results['summary']['used_files'] > 0
    
    # Check that main files are not marked as unused
    main_files = ['draft/main.tex', 'proposal/main.tex', 'make.sh']
    for main_file in main_files:
        assert main_file not in results['unused_files'], f"{main_file} should not be unused"
    
    print("✓ Real repository test passed")
    print(f"  - Total files: {results['summary']['total_files']}")
    print(f"  - Used files: {results['summary']['used_files']}")
    print(f"  - Unused files: {results['summary']['unused_files']}")
    print(f"  - Usage rate: {results['summary']['usage_rate']:.1f}%")


def main():
    """Run all tests."""
    print("Running unused code detection tests...")
    print()
    
    try:
        test_basic_functionality()
        test_sample_file_detection()
        test_real_repository()
        
        print()
        print("All tests passed! ✓")
        
    except Exception as e:
        print(f"Test failed: {e}")
        return 1
        
    return 0


if __name__ == "__main__":
    exit(main())