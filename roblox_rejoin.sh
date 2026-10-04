#!/data/data/com.termux/files/usr/bin/bash

GAME_URL="roblox://placeId=113290951185459"
PACKAGE="com.roblox.client"

# ตรวจสอบทุกกี่วินาที
CHECK_DELAY=10

# รีสตาร์ต Roblox ทุกกี่วินาที
RESTART_INTERVAL=3600

# ถ้าเน็ตหายเกินเวลานี้ จะถือว่าหลุด
OUTAGE_REJOIN_AFTER=30

# เวลารอหลังเปิด Roblox
LAUNCH_WAIT=90

last_restart=$(date +%s)
down_since=0

echo "================================="
echo " Roblox Auto Rejoin"
echo " Anime Dice"
echo " PlaceId: 113290951185459"
echo "================================="
echo "กด CTRL+C เพื่อหยุด"
echo ""

open_game() {
    echo "[+] กำลังเปิด Anime Dice..."

    am start \
        -a android.intent.action.VIEW \
        -d "$GAME_URL" \
        -p "$PACKAGE" >/dev/null 2>&1
}

stop_roblox() {
    echo "[!] กำลังปิด Roblox..."

    am force-stop "$PACKAGE"

    sleep 5
}

restart_roblox() {
    stop_roblox
    open_game

    last_restart=$(date +%s)

    echo "[+] รอ Roblox เข้าเกม ${LAUNCH_WAIT} วินาที..."
    sleep "$LAUNCH_WAIT"
}

internet_ok() {
    ping -c 1 -W 3 1.1.1.1 >/dev/null 2>&1
}

while true; do

    NOW=$(date +%s)

    # =========================
    # ตรวจอินเทอร์เน็ต
    # =========================

    if ! internet_ok; then

        if [ "$down_since" -eq 0 ]; then
            down_since=$NOW
            echo "[!] อินเทอร์เน็ตหลุด..."
        fi

        OUTAGE_TIME=$((NOW - down_since))

        echo "[!] เน็ตหายแล้ว ${OUTAGE_TIME} วินาที"

    else

        # =========================
        # เน็ตกลับมา
        # =========================

        if [ "$down_since" -ne 0 ]; then

            OUTAGE_TIME=$((NOW - down_since))

            echo "[+] อินเทอร์เน็ตกลับมาแล้ว"
            echo "[+] เน็ตหายไป ${OUTAGE_TIME} วินาที"

            if [ "$OUTAGE_TIME" -ge "$OUTAGE_REJOIN_AFTER" ]; then

                echo "[!] ตรวจพบเน็ตหลุดนาน"
                echo "[!] กำลัง Rejoin Anime Dice..."

                restart_roblox

            elif ! pidof "$PACKAGE" >/dev/null 2>&1; then

                echo "[!] Roblox ปิดอยู่"
                echo "[+] กำลังเข้า Anime Dice..."

                open_game
                last_restart=$(date +%s)

                sleep "$LAUNCH_WAIT"
            fi

            down_since=0
        fi

        # =========================
        # ตรวจ Roblox ปิด
        # =========================

        if ! pidof "$PACKAGE" >/dev/null 2>&1; then

            echo "[!] Roblox ไม่ทำงาน"
            echo "[+] กำลัง Rejoin Anime Dice..."

            open_game

            last_restart=$(date +%s)

            sleep "$LAUNCH_WAIT"
        fi

        # =========================
        # รีสตาร์ตทุก 1 ชั่วโมง
        # =========================

        NOW=$(date +%s)
        RUN_TIME=$((NOW - last_restart))

        if [ "$RUN_TIME" -ge "$RESTART_INTERVAL" ]; then

            echo ""
            echo "================================="
            echo "[!] ครบ 1 ชั่วโมงแล้ว"
            echo "[+] กำลังรีสตาร์ต Roblox"
            echo "================================="

            restart_roblox
        fi

    fi

    sleep "$CHECK_DELAY"

done
