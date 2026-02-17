#!/bin/bash
# ngrok launcher - run this in a SEPARATE terminal while app.py is running

echo "================================================"
echo "  NGROK TUNNEL LAUNCHER"
echo "================================================"
echo ""

if ! command -v ngrok &>/dev/null; then
    echo "[!] ngrok not found!"
    echo "[*] Install it from: https://ngrok.com/download"
    echo "[*] Or run: sudo snap install ngrok"
    exit 1
fi

# Check if auth token is set
if ! ngrok config check &>/dev/null 2>&1; then
    echo "[!] ngrok auth token not set!"
    echo ""
    echo "Steps:"
    echo "  1. Go to: https://ngrok.com (free account)"
    echo "  2. Get your authtoken from dashboard"
    echo "  3. Run: ngrok config add-authtoken YOUR_TOKEN"
    echo ""
    echo "Then run this script again."
    exit 1
fi

echo "[*] Starting ngrok tunnel on port 5000..."
echo "[*] Look for 'Forwarding https://...' URL below"
echo "[*] Use that URL on your other devices"
echo ""
ngrok http 5000
