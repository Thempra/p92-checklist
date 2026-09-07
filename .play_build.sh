#!/bin/bash
# Build the release AAB for API 36, idempotent: skips if already built with API 36.
BASE=/home/hermes/p92-checklist
AAB="$BASE/build/app/outputs/bundle/release/app-release.aab"
LOG="$BASE/.play_build.log"

# Only proceed if not already built or if build missing
if [ -f "$AAB" ]; then
  echo "$(date) AAB already present, done." >> "$LOG"
  exit 0
fi

export PATH=$HOME/flutter/bin:$PATH
cd "$BASE"
echo "$(date) START build" >> "$LOG"
flutter build appbundle --release >> "$LOG" 2>&1
echo "$(date) EXIT=$?" >> "$LOG"
if [ -f "$AAB" ]; then
  echo "$(date) SUCCESS size=$(stat -c%s "$AAB")" >> "$LOG"
else
  echo "$(date) FAILED" >> "$LOG"
fi
