#!/bin/bash
# Quick launcher for Device Inspector

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

LOCAL_IP=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d'/' -f1 | head -1)

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════╗"
echo "║          DEVICE INSPECTOR - LAUNCHER            ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${GREEN}[+] Local URL:   http://localhost:5000${NC}"
echo -e "${GREEN}[+] Network URL: http://$LOCAL_IP:5000${NC}"
echo -e "${YELLOW}[*] For internet access, run in another terminal:${NC}"
echo -e "${YELLOW}    ngrok http 5000${NC}"
echo ""
echo -e "${CYAN}[*] Starting server... (Ctrl+C to stop)${NC}"
echo ""

python3 ~/device_inspector/app.py
