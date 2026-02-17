#!/bin/bash
# ================================================
#  URL MASKING GUIDE — WeatherLive Pro by Dhiru
#  Make ngrok URL look realistic
# ================================================

C='\033[0;36m'; G='\033[0;32m'; Y='\033[1;33m'
W='\033[1;37m'; DIM='\033[2m'; NC='\033[0m'

echo -e "${C}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║      URL MASKING GUIDE — by Dhiru                   ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${Y}Your ngrok URL will look like:${NC}"
echo -e "  ${DIM}https://abc123def.ngrok-free.app${NC}"
echo ""
echo -e "${Y}To make it look like a REAL weather site:${NC}"
echo ""

echo -e "${G}METHOD 1: Use URL Endpoints (Already in your app!)${NC}"
echo -e "  Your app already has these realistic paths:"
echo -e "  ${W}https://yourngrok.ngrok-free.app/forecast${NC}  ← Best!"
echo -e "  ${W}https://yourngrok.ngrok-free.app/weather${NC}"
echo -e "  ${W}https://yourngrok.ngrok-free.app/live${NC}"
echo ""

echo -e "${G}METHOD 2: TinyURL (Free, instant)${NC}"
echo -e "  1. Go to: ${W}https://tinyurl.com/app${NC}"
echo -e "  2. Paste your ngrok URL"
echo -e "  3. Set custom alias like: ${W}weatherlive-dhiru${NC}"
echo -e "  Result: ${W}https://tinyurl.com/weatherlive-dhiru${NC}"
echo ""

echo -e "${G}METHOD 3: Bit.ly (Professional)${NC}"
echo -e "  1. Go to: ${W}https://bit.ly${NC}"
echo -e "  2. Free account banao"
echo -e "  3. Custom link: ${W}bit.ly/my-weather-app${NC}"
echo ""

echo -e "${G}METHOD 4: is.gd (Instant, no account)${NC}"
if command -v curl &>/dev/null; then
    echo -e "  ${DIM}Run this to auto-shorten:${NC}"
    echo -e "  ${W}curl -s 'https://is.gd/create.php?format=simple&url=YOUR_NGROK_URL'${NC}"
    echo ""
    read -p "  Paste your ngrok URL to shorten now (or press Enter to skip): " NGROK_URL
    if [ ! -z "$NGROK_URL" ]; then
        SHORT=$(curl -s "https://is.gd/create.php?format=simple&url=$NGROK_URL")
        if [ ! -z "$SHORT" ]; then
            echo -e "\n  ${G}✓ Shortened URL: ${W}$SHORT${NC}"
            echo -e "  ${G}✓ With path:     ${W}${SHORT}/forecast${NC}"
        fi
    fi
fi

echo ""
echo -e "${G}METHOD 5: ngrok Custom Domain (Paid — most realistic)${NC}"
echo -e "  ${DIM}Paid ngrok plan pe apna domain add kar sakte ho:${NC}"
echo -e "  ${W}https://weather-dhiru.ngrok.app${NC}"
echo ""

echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${Y}BEST STRATEGY:${NC}"
echo -e "  1. ngrok URL copy karo"
echo -e "  2. /forecast path add karo"
echo -e "  3. tinyurl.com se short karo"
echo -e "  4. Share karo!"
echo -e ""
echo -e "  ${G}Example: ${W}https://tinyurl.com/live-weather-check${NC}"
echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${DIM}WeatherLive Pro — Made by Dhiru${NC}"
