#!/bin/bash

# GYFOOYA January 2026
#
# YT-DLP bulletproof 0.4
# Usage: ./ytmp3.sh VIDEO_URL
#
# pacman -Syu yt-dlp nodejs npm

URL="$1"

yt-dlp \
--cookies-from-browser firefox \
--geo-bypass \
--remote-components ejs:github \
-x --audio-format mp3 \
--add-metadata --embed-thumbnail \
--format "bestaudio/best[ext!=webm]/best" \
--merge-output-format mp3 \
"$URL"

#Downloads the best audio if available.
#Falls back to the lowest combined video+audio if audio-only fails.
#Converts everything to MP3.
#Adds metadata and embeds thumbnails.
#The / symbol is a fallback operator in yt-dlp format selectors :-)
