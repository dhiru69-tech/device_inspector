#!/bin/bash
# ================================================
#  Device Inspector - Full Auto Installer
#  Kali Linux only | Personal use only
# ================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════╗"
echo "║       DEVICE INSPECTOR - AUTO INSTALLER         ║"
echo "║           Kali Linux Setup Script               ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo -e "${RED}[!] This script is designed for Kali Linux only!${NC}"
    exit 1
fi

# Check internet
echo -e "${YELLOW}[*] Checking internet connection...${NC}"
if ping -c 1 google.com &>/dev/null; then
    echo -e "${GREEN}[+] Internet OK${NC}"
else
    echo -e "${RED}[!] No internet connection! Please connect first.${NC}"
    exit 1
fi

# ------------------------------------------------
# STEP 1: System Update
# ------------------------------------------------
echo -e "\n${CYAN}[STEP 1] Updating system packages...${NC}"
sudo apt update -y 2>/dev/null | tail -1
echo -e "${GREEN}[+] System updated${NC}"

# ------------------------------------------------
# STEP 2: Python3 & pip
# ------------------------------------------------
echo -e "\n${CYAN}[STEP 2] Checking Python3...${NC}"

if command -v python3 &>/dev/null; then
    PY_VERSION=$(python3 --version)
    echo -e "${GREEN}[+] $PY_VERSION already installed${NC}"
else
    echo -e "${YELLOW}[*] Installing Python3...${NC}"
    sudo apt install python3 -y
fi

if command -v pip3 &>/dev/null; then
    echo -e "${GREEN}[+] pip3 already installed${NC}"
else
    echo -e "${YELLOW}[*] Installing pip3...${NC}"
    sudo apt install python3-pip -y
fi

# ------------------------------------------------
# STEP 3: Python Libraries
# ------------------------------------------------
echo -e "\n${CYAN}[STEP 3] Installing Python libraries...${NC}"

PYTHON_LIBS=("flask" "requests" "flask-cors")

for lib in "${PYTHON_LIBS[@]}"; do
    echo -e "${YELLOW}[*] Installing $lib...${NC}"
    pip3 install $lib --break-system-packages -q
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] $lib installed successfully${NC}"
    else
        echo -e "${RED}[!] Failed to install $lib${NC}"
    fi
done

# ------------------------------------------------
# STEP 4: ngrok
# ------------------------------------------------
echo -e "\n${CYAN}[STEP 4] Installing ngrok (for internet access)...${NC}"

if command -v ngrok &>/dev/null; then
    echo -e "${GREEN}[+] ngrok already installed${NC}"
else
    echo -e "${YELLOW}[*] Downloading ngrok...${NC}"
    
    # Detect architecture
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"
    elif [[ "$ARCH" == "aarch64" ]]; then
        NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz"
    else
        NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-386.tgz"
    fi
    
    # Try snap first (easier)
    if command -v snap &>/dev/null; then
        sudo snap install ngrok 2>/dev/null
        if command -v ngrok &>/dev/null; then
            echo -e "${GREEN}[+] ngrok installed via snap${NC}"
        fi
    fi
    
    # If snap failed, try direct download
    if ! command -v ngrok &>/dev/null; then
        wget -q "$NGROK_URL" -O /tmp/ngrok.tgz
        if [ $? -eq 0 ]; then
            tar -xzf /tmp/ngrok.tgz -C /tmp/
            sudo mv /tmp/ngrok /usr/local/bin/ngrok
            sudo chmod +x /usr/local/bin/ngrok
            rm /tmp/ngrok.tgz
            echo -e "${GREEN}[+] ngrok installed successfully${NC}"
        else
            echo -e "${RED}[!] ngrok download failed. Install manually from: https://ngrok.com/download${NC}"
        fi
    fi
fi

# ------------------------------------------------
# STEP 5: Additional useful tools
# ------------------------------------------------
echo -e "\n${CYAN}[STEP 5] Installing additional network tools...${NC}"

TOOLS=("net-tools" "curl" "wget" "jq")

for tool in "${TOOLS[@]}"; do
    if command -v $tool &>/dev/null || dpkg -l $tool &>/dev/null 2>&1; then
        echo -e "${GREEN}[+] $tool already installed${NC}"
    else
        echo -e "${YELLOW}[*] Installing $tool...${NC}"
        sudo apt install $tool -y -q
        echo -e "${GREEN}[+] $tool installed${NC}"
    fi
done

# ------------------------------------------------
# STEP 6: Create project directory & copy files
# ------------------------------------------------
echo -e "\n${CYAN}[STEP 6] Setting up project directory...${NC}"

PROJECT_DIR="$HOME/device_inspector"
mkdir -p "$PROJECT_DIR"
mkdir -p "$PROJECT_DIR/results"

# Create results.json if not exists
touch "$PROJECT_DIR/results.json"

echo -e "${GREEN}[+] Project directory created: $PROJECT_DIR${NC}"

# ------------------------------------------------
# STEP 7: Create run script
# ------------------------------------------------
cat > "$PROJECT_DIR/run.sh" << 'RUNSCRIPT'
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
RUNSCRIPT

chmod +x "$PROJECT_DIR/run.sh"

# ------------------------------------------------
# STEP 8: Create ngrok launcher
# ------------------------------------------------
cat > "$PROJECT_DIR/start_ngrok.sh" << 'NGROKSCRIPT'
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
NGROKSCRIPT

chmod +x "$PROJECT_DIR/start_ngrok.sh"

# ------------------------------------------------
# STEP 9: Verify everything
# ------------------------------------------------
echo -e "\n${CYAN}[STEP 9] Verifying installation...${NC}"

echo ""
echo -e "${WHITE}Checking installed components:${NC}"

# Python
python3 --version &>/dev/null && echo -e "${GREEN}  ✓ Python3${NC}" || echo -e "${RED}  ✗ Python3${NC}"

# pip
pip3 --version &>/dev/null && echo -e "${GREEN}  ✓ pip3${NC}" || echo -e "${RED}  ✗ pip3${NC}"

# Flask
python3 -c "import flask" 2>/dev/null && echo -e "${GREEN}  ✓ Flask${NC}" || echo -e "${RED}  ✗ Flask${NC}"

# Requests
python3 -c "import requests" 2>/dev/null && echo -e "${GREEN}  ✓ requests${NC}" || echo -e "${RED}  ✗ requests${NC}"

# ngrok
command -v ngrok &>/dev/null && echo -e "${GREEN}  ✓ ngrok${NC}" || echo -e "${YELLOW}  ⚠ ngrok (install manually if needed)${NC}"

# curl
command -v curl &>/dev/null && echo -e "${GREEN}  ✓ curl${NC}" || echo -e "${RED}  ✗ curl${NC}"

# jq
command -v jq &>/dev/null && echo -e "${GREEN}  ✓ jq${NC}" || echo -e "${YELLOW}  ⚠ jq${NC}"

# ------------------------------------------------
# DONE
# ------------------------------------------------
LOCAL_IP=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d'/' -f1 | head -1)

echo -e "\n${GREEN}"
echo "╔══════════════════════════════════════════════════╗"
echo "║           INSTALLATION COMPLETE!                ║"
echo "╠══════════════════════════════════════════════════╣"
echo "║                                                  ║"
echo "║  Make sure app.py is in ~/device_inspector/     ║"
echo "║                                                  ║"
echo "║  TO START:                                       ║"
echo "║    bash ~/device_inspector/run.sh               ║"
echo "║                                                  ║"
echo "║  FOR INTERNET ACCESS (separate terminal):        ║"
echo "║    bash ~/device_inspector/start_ngrok.sh       ║"
echo "║                                                  ║"
echo "║  YOUR LOCAL IP: $LOCAL_IP                   ║"
echo "║                                                  ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

