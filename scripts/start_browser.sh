#!/bin/bash

# Change to the parent directory (REDocs root)
cd "$(dirname "$0")/.."

# Literature Browser Server Script
# This script starts a local HTTP server and opens the literature browser

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PORT=8000
URL="http://localhost:$PORT/browser.html"

echo -e "${BLUE}📚 Starting Literature Browser Server...${NC}"
echo -e "${YELLOW}Default Port: $PORT (server will find available port if needed)${NC}"
echo ""

# Start the custom server in the background
echo -e "${BLUE}🚀 Starting Literature Browser server...${NC}"
python3 server.py &
SERVER_PID=$!

# Wait for server to start and extract the actual port
sleep 3

# Extract port from server output (will be in logs)
# For now, we'll try the default port and common alternatives
ACTUAL_PORT=""
for port in 8000 8001 8002 8003 8004 8005 8006 8007 8008 8009 8010; do
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        ACTUAL_PORT=$port
        break
    fi
done

if [ -n "$ACTUAL_PORT" ]; then
    URL="http://localhost:$ACTUAL_PORT/browser.html"
    echo -e "${GREEN}✅ Server started successfully on port $ACTUAL_PORT${NC}"
    echo -e "${BLUE}🌐 Opening literature browser in your default browser...${NC}"
    
    # Try different ways to open the browser depending on the OS
    if command -v xdg-open > /dev/null; then
        xdg-open "$URL" 2>/dev/null
    elif command -v open > /dev/null; then
        open "$URL" 2>/dev/null
    elif command -v firefox > /dev/null; then
        firefox "$URL" 2>/dev/null &
    elif command -v chromium-browser > /dev/null; then
        chromium-browser "$URL" 2>/dev/null &
    elif command -v google-chrome > /dev/null; then
        google-chrome "$URL" 2>/dev/null &
    else
        echo -e "${YELLOW}⚠️  Could not automatically open browser. Please manually open:${NC}"
        echo -e "${BLUE}   $URL${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}📖 Literature Browser is now running!${NC}"
    echo -e "${BLUE}   Access it at: $URL${NC}"
    echo -e "${BLUE}   Bibliography update available via UI button${NC}"
    echo ""
    echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
    echo ""
else
    echo -e "${YELLOW}⚠️  Could not detect server port. Please check manually at:${NC}"
    echo -e "${BLUE}   http://localhost:8000/browser.html${NC}"
    echo -e "${BLUE}   http://localhost:8001/browser.html${NC}"
    echo -e "${BLUE}   http://localhost:8002/browser.html${NC}"
fi

# Wait for user to stop the server
trap "echo -e '\n${BLUE}🛑 Stopping server...${NC}'; kill $SERVER_PID 2>/dev/null; echo -e '${GREEN}✅ Server stopped${NC}'; exit 0" INT

# Keep the script running
wait $SERVER_PID
