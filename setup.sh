#!/bin/bash
# ================================================
#  Device Inspector - Setup Script (Kali Linux)
#  Personal use only - self testing tool
# ================================================

echo "================================================"
echo "   DEVICE INSPECTOR - SETUP"
echo "================================================"

# Install dependencies
echo "[*] Installing Python dependencies..."
pip install flask --break-system-packages -q

# Create results directory
mkdir -p ~/device_inspector

# Get local IP
LOCAL_IP=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d'/' -f1 | head -1)

echo ""
echo "[+] Setup complete!"
echo ""
echo "================================================"
echo "  HOW TO USE:"
echo "================================================"
echo ""
echo "  1. Start server:"
echo "     python3 ~/device_inspector/app.py"
echo ""
echo "  2. Access from same WiFi:"
echo "     http://$LOCAL_IP:5000"
echo ""
echo "  3. Access from internet (ngrok):"
echo "     ngrok http 5000"
echo "     (use the https URL given by ngrok)"
echo ""
echo "  4. View collected data:"
echo "     http://localhost:5000/results"
echo "     OR: cat ~/device_inspector/results.json"
echo ""
echo "================================================"
echo "  YOUR LOCAL IP: $LOCAL_IP"
echo "================================================"
