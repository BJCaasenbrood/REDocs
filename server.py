#!/usr/bin/env python3
"""
Literature Browser Server
A simple HTTP server that serves the literature browser and handles bibliography updates.
"""

import http.server
import socketserver
import urllib.parse
import subprocess
import json
import os
import sys
from pathlib import Path

class LiteratureBrowserHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        """Handle POST requests for bibliography updates"""
        if self.path == '/update-bib':
            self.handle_update_bib()
        else:
            self.send_error(404, "Not Found")
    
    def handle_update_bib(self):
        """Execute the update_bib.sh script and return the result"""
        try:
            # Set content type for JSON response
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            # Execute the update_bib.sh script
            print("📚 Executing update_bib.sh script...")
            result = subprocess.run(
                ['./update_bib.sh'], 
                cwd=os.getcwd(),
                capture_output=True, 
                text=True, 
                timeout=300  # 5 minute timeout
            )
            
            # Prepare response
            response = {
                'success': result.returncode == 0,
                'returncode': result.returncode,
                'stdout': result.stdout,
                'stderr': result.stderr
            }
            
            # Log the result
            if result.returncode == 0:
                print("✅ update_bib.sh completed successfully")
                if result.stdout:
                    print("Output:", result.stdout)
            else:
                print(f"❌ update_bib.sh failed with return code {result.returncode}")
                if result.stderr:
                    print("Error:", result.stderr)
            
            # Send JSON response
            self.wfile.write(json.dumps(response).encode())
            
        except subprocess.TimeoutExpired:
            self.send_response(500)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            response = {
                'success': False,
                'error': 'Script execution timed out (5 minutes)',
                'timeout': True
            }
            self.wfile.write(json.dumps(response).encode())
            print("⏰ update_bib.sh timed out after 5 minutes")
            
        except Exception as e:
            self.send_response(500)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            response = {
                'success': False,
                'error': str(e)
            }
            self.wfile.write(json.dumps(response).encode())
            print(f"❌ Error executing update_bib.sh: {e}")
    
    def do_OPTIONS(self):
        """Handle OPTIONS requests for CORS preflight"""
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
    
    def log_message(self, format, *args):
        """Override to provide cleaner logging"""
        if not self.path.startswith('/update-bib'):
            # Only log non-API requests to reduce noise
            return
        print(f"📡 {self.address_string()} - {format % args}")

def find_available_port(start_port=8000, max_attempts=10):
    """Find an available port starting from start_port"""
    import socket
    for port in range(start_port, start_port + max_attempts):
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.bind(('localhost', port))
                return port
        except OSError:
            continue
    return None

def main():
    # Find available port
    port = find_available_port()
    if port is None:
        print("❌ Could not find an available port")
        sys.exit(1)
    
    # Ensure update_bib.sh is executable
    update_bib_path = Path('./update_bib.sh')
    if update_bib_path.exists():
        os.chmod(update_bib_path, 0o755)
        print("✅ Made update_bib.sh executable")
    else:
        print("⚠️  Warning: update_bib.sh not found")
    
    # Start server
    try:
        with socketserver.TCPServer(("", port), LiteratureBrowserHandler) as httpd:
            print(f"🚀 Literature Browser Server starting on port {port}")
            print(f"🌐 Access at: http://localhost:{port}/literature_browser.html")
            print(f"📚 Bibliography update endpoint: http://localhost:{port}/update-bib")
            print("\nPress Ctrl+C to stop the server")
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Server stopped by user")
    except Exception as e:
        print(f"❌ Server error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
