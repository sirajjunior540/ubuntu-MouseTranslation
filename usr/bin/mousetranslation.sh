#!/bin/bash

API_KEY="<YOUR_API_KEY>"  # Placeholder, will be replaced during installation
TARGET_LANG="ar"
LAST_TRANSLATED_TEXT=""
LAST_CLIPBOARD_TEXT=""

# Function to run the main loop
run_translation() {
    while true; do
        eval $(xdotool getmouselocation --shell)
        WINDOW_ID=$(xdotool getwindowfocus)
        WINDOW_NAME=$(xdotool getwindowname $WINDOW_ID)
        echo "Window: $WINDOW_NAME"
        xclip -o > /tmp/clipboard_text.txt
        CLIPBOARD_TEXT=$(cat /tmp/clipboard_text.txt)
        if [ "$CLIPBOARD_TEXT" != "$LAST_CLIPBOARD_TEXT" ]; then
            LAST_CLIPBOARD_TEXT="$CLIPBOARD_TEXT"
            RESPONSE=$(curl -s -X POST \
              -H "Content-Type: application/json" \
              -d "{\"q\":\"$CLIPBOARD_TEXT\",\"target\":\"$TARGET_LANG\"}" \
              "https://translation.googleapis.com/language/translate/v2?key=$API_KEY")
            echo "API Response: $RESPONSE"
            TRANSLATED_TEXT=$(echo $RESPONSE | jq -r '.data.translations[0].translatedText' 2>/dev/null)
            if [ ! -z "$TRANSLATED_TEXT" ] && [ "$TRANSLATED_TEXT" != "null" ]; then
                LAST_TRANSLATED_TEXT="$TRANSLATED_TEXT"
                eval $(xdotool getmouselocation --shell)
                X=$(xdotool getmouselocation --shell | grep -Eo 'X=[0-9]+' | grep -Eo '[0-9]+')
                Y=$(xdotool getmouselocation --shell | grep -Eo 'Y=[0-9]+' | grep -Eo '[0-9]+')
                (echo "$TRANSLATED_TEXT"; sleep 3) | zenity --notification --text="$TRANSLATED_TEXT" --timeout=3 --width=200 --height=100 --title="Translation"
            else
                echo "Translation failed or no translation found"
                ERROR_MESSAGE=$(echo $RESPONSE | jq -r '.error.message' 2>/dev/null)
                if [ ! -z "$ERROR_MESSAGE" ] && [ "$ERROR_MESSAGE" != "null" ]; then
                    echo "Error Message: $ERROR_MESSAGE"
                fi
            fi
        fi
        sleep 0.5
    done
}

# Function to create tray icon
create_tray_icon() {
    python3 - <<EOF
import pystray
from pystray import Icon as icon, Menu as menu, MenuItem as item
from PIL import Image, ImageDraw
import os

def on_exit(icon, item):
    os._exit(0)

def create_image():
    width = 64
    height = 64
    color1 = (255, 255, 255)
    color2 = (0, 0, 0)

    image = Image.new('RGB', (width, height), color1)
    dc = ImageDraw.Draw(image)
    dc.rectangle(
        [(width // 2, 0), (width, height // 2)],
        fill=color2)
    dc.rectangle(
        [(0, height // 2), (width // 2, height)],
        fill=color2)

    return image

icon = icon("mousetranslation", create_image(), menu=menu(item('Quit', on_exit)))
icon.run()
EOF
}

# Run the translation function in the background
run_translation &
TRANSLATION_PID=$!

# Create tray icon
create_tray_icon

# Wait for user to stop the app
kill $TRANSLATION_PID
