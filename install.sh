#!/data/data/com.termux/files/usr/bin/bash

REPO="https://raw.githubusercontent.com/arounxaillhc-cyber/Roblox-Rejoin/main"

echo "================================="
echo " Roblox Rejoin Installer"
echo "================================="
echo ""

echo "[1/2] Checking requirements..."

if ! command -v curl >/dev/null 2>&1; then
    echo "Installing curl..."
    pkg install curl -y
fi

echo "[2/2] Downloading files..."

curl -fsSL "$REPO/roblox_rejoin.sh" -o "$HOME/roblox_rejoin.sh"
curl -fsSL "$REPO/start" -o "$HOME/start"
curl -fsSL "$REPO/stop" -o "$HOME/stop"
curl -fsSL "$REPO/update" -o "$HOME/update"
curl -fsSL "$REPO/status" -o "$HOME/status"

chmod +x \
    "$HOME/roblox_rejoin.sh" \
    "$HOME/start" \
    "$HOME/stop" \
    "$HOME/update" \
    "$HOME/status"

# เพิ่ม Home เข้า PATH
if ! grep -qxF 'export PATH="$HOME:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME:$PATH"' >> "$HOME/.bashrc"
fi

# ใช้งาน PATH ทันทีโดยไม่ต้องเปิด Termux ใหม่
export PATH="$HOME:$PATH"

echo ""
echo "================================="
echo " Installation complete!"
echo "================================="
echo ""
echo "Commands:"
echo "  start  - Start Roblox Rejoin"
echo "  stop   - Stop Roblox Rejoin"
echo "  update - Update from GitHub"
echo "  status - Check status"
echo ""
