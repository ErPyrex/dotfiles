#!/usr/bin/env bash

CONFIG_FILE="$HOME/.var/app/io.github.jeffshee.Hidamari/config/hidamari/config.json"
TARGET_DIR="$HOME/Vídeos/Hidamari"

mkdir -p "$TARGET_DIR"

# Si el usuario pasó un video como argumento (ej: start-animated-wallpaper.sh video.mp4)
if [ -n "$1" ]; then
    if [ ! -f "$1" ]; then
        echo "Error: El archivo de video '$1' no existe." >&2
        exit 1
    fi

    VIDEO_PATH="$(realpath "$1")"
    DEST_PATH="$TARGET_DIR/$(basename "$VIDEO_PATH")"

    # Si el video no está ya en la carpeta de Hidamari, copiarlo
    if [ "$VIDEO_PATH" != "$DEST_PATH" ]; then
        echo "Copiando video a $TARGET_DIR..."
        cp "$VIDEO_PATH" "$DEST_PATH"
    fi

    # Actualizar la ruta en el config.json de Hidamari preservando monitores
    python3 -c "
import json, os, subprocess

cfg_path = os.path.expanduser('$CONFIG_FILE')
dest_path = '$DEST_PATH'

os.makedirs(os.path.dirname(cfg_path), exist_ok=True)
try:
    with open(cfg_path, 'r') as f:
        data = json.load(f)
except Exception:
    data = {'version': 4, 'mode': 'MODE_VIDEO', 'data_source': {}, 'is_mute': True}

data['mode'] = 'MODE_VIDEO'
data['is_mute'] = True
data['is_pause_when_maximized'] = True

if 'data_source' not in data or not isinstance(data['data_source'], dict):
    data['data_source'] = {}

# Preservar monitores existentes y detectar monitores activos vía xrandr
monitors = set(data['data_source'].keys())
try:
    out = subprocess.check_output(['xrandr', '--listmonitors']).decode('utf-8', errors='ignore')
    for line in out.splitlines():
        parts = line.strip().split()
        if len(parts) >= 4 and parts[0].endswith(':'):
            mon = parts[-1]
            if mon:
                monitors.add(mon)
except Exception:
    pass

monitors.add('Default')
monitors.add('eDP-1')

for m in monitors:
    data['data_source'][m] = dest_path

with open(cfg_path, 'w') as f:
    json.dump(data, f, indent=3)
"
    echo "Fondo actualizado a: $(basename "$DEST_PATH")"
fi

# Detener cualquier instancia previa de Hidamari para reiniciar limpiamente
flatpak kill io.github.jeffshee.Hidamari 2>/dev/null
pkill -f "hidamari" 2>/dev/null
sleep 1

# Iniciar Hidamari en modo segundo plano (-b) completamente desvinculado
setsid flatpak run --command=hidamari io.github.jeffshee.Hidamari -b >/dev/null 2>&1 &

# Esperar a que la ventana de video se dibuje en pantalla
sleep 2.5

# Reordenar las capas de ventanas sin robar el foco activo
if command -v fix-icons >/dev/null 2>&1; then
    fix-icons --quiet
elif [ -x "$HOME/.local/bin/fix-icons" ]; then
    "$HOME/.local/bin/fix-icons" --quiet
fi
