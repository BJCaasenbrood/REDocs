#!/bin/bash

# Literature Browser Server Script
# This script starts a local HTTP server and opens the literature browser

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PORT=8000
URL="http://localhost:$PORT/literature_browser.html"

echo -e "${BLUE}📚 Starting Literature Browser Server...${NC}"
echo -e "${YELLOW}Port: $PORT${NC}"
echo -e "${YELLOW}URL: $URL${NC}"
echo ""

# Check if port is already in use
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Port $PORT is already in use. Trying to find an available port...${NC}"
    # Try ports 8001-8010
    for port in {8001..8010}; do
        if ! lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            PORT=$port
            URL="http://localhost:$PORT/literature_browser.html"
            echo -e "${GREEN}✅ Using port $PORT instead${NC}"
            break
        fi
    done
fi

# Start the server in the background
echo -e "${BLUE}🚀 Starting HTTP server on port $PORT...${NC}"
python3 -m http.server $PORT > /dev/null 2>&1 &
SERVER_PID=$!

# Wait a moment for server to start
sleep 2

# Check if server started successfully
if kill -0 $SERVER_PID 2>/dev/null; then
    echo -e "${GREEN}✅ Server started successfully (PID: $SERVER_PID)${NC}"
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
    echo ""
    echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
    echo ""
    
    # Wait for user to stop the server
    trap "echo -e '\n${BLUE}🛑 Stopping server...${NC}'; kill $SERVER_PID 2>/dev/null; echo -e '${GREEN}✅ Server stopped${NC}'; exit 0" INT
    
    # Keep the script running
    wait $SERVER_PID
else
    echo -e "${RED}❌ Failed to start server${NC}"
    exit 1
fi
