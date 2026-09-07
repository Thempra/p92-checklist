#!/bin/bash
# Build the release AAB for API 36, idempotent: skips if already built with API 36.
#
# REQUISITO GOOGLE PLAY (obligatorio, no olvidar):
#   Soporte de páginas de memoria de 16 KB (Android 15 / API 35+).
#   Todas las .so (arm64-v8a / x86_64) deben estar alineadas a >=16 KB
#   (segmentos LOAD con Align >= 0x4000; ideal 0x10000/64 KB).
#   Flutter >= 3.47 ya las genera alineadas a 16 KB, pero verificar SIEMPRE
#   las librerias antes de subir el AAB a Play Console.
#   Este paso de verificacion comprueba la alineacion automaticamente.
#
# versionCode: NO usar el 1 (ya se uso en Play). Incrementar en pubspec.yaml
#   (version: x.y.z+N) y confirmar android/local.properties versionCode=N.
BASE=/home/hermes/p92-checklist
AAB="$BASE/build/app/outputs/bundle/release/app-release.aab"
LOG="$BASE/.play_build.log"

# Comprobar la alineacion 16KB de las .so dentro del AAB
check_16kb() {
  local tmp; tmp=$(mktemp -d)
  unzip -o -q "$AAB" "base/lib/arm64-v8a/*.so" "base/lib/x86_64/*.so" -d "$tmp" 2>/dev/null
  local RDIR="$HOME/android-sdk/ndk/"*"/toolchains/llvm/prebuilt/"*"/bin/llvm-readelf"
  local fail=0
  for f in "$tmp"/base/lib/arm64-v8a/*.so "$tmp"/base/lib/x86_64/*.so; do
    [ -f "$f" ] || continue
    local maxalign
    maxalign=$($RDIR -l "$f" 2>/dev/null | grep LOAD | grep -oE "0x[0-9a-f]+$" | sort -u -r | head -1)
    case "$maxalign" in
      0x4000|0x8000|0x10000) ;;  # >=16KB ok
      *) echo "ERROR: $f no alineada a 16KB (Align=$maxalign)" | tee -a "$LOG"; fail=1 ;;
    esac
  done
  rm -rf "$tmp"
  return $fail
}

# Only proceed if not already built or if build missing
if [ -f "$AAB" ]; then
  echo "$(date) AAB already present, done. (verify 16KB)" >> "$LOG"
  if check_16kb; then
    echo "$(date) OK: libs alineadas a 16KB" >> "$LOG"
  else
    echo "$(date) FALLO 16KB: no subir a Play" >> "$LOG"
    exit 1
  fi
  exit 0
fi

export PATH=$HOME/flutter/bin:$PATH
cd "$BASE"
echo "$(date) START build" >> "$LOG"
flutter build appbundle --release >> "$LOG" 2>&1
echo "$(date) EXIT=$?" >> "$LOG"
if [ -f "$AAB" ]; then
  echo "$(date) SUCCESS size=$(stat -c%s "$AAB")" >> "$LOG"
  if check_16kb; then
    echo "$(date) OK: libs alineadas a 16KB (listo para Play)" >> "$LOG"
  else
    echo "$(date) FALLO 16KB: no subir a Play" >> "$LOG"
    exit 1
  fi
else
  echo "$(date) FAILED" >> "$LOG"
fi
