# Guía Integral: Fondos de Pantalla Animados en Linux Mint (Cinnamon / X11)

Este documento detalla paso a paso la instalación, resolución del conflicto de iconos con el gestor de escritorio Nemo, automatización y mantenimiento de fondos animados en **Linux Mint**.

---

## 1. Información del Entorno del Sistema

* **Sistema Operativo:** Linux Mint 22.3 (Zena) basado en Ubuntu 24.04 (Noble)
* **Entorno de Escritorio:** Cinnamon (`X-Cinnamon` / `cinnamon`)
* **Servidor Gráfico:** X11
* **Gestor de Ventanas:** Muffin (gestor basado en Mutter/Clutter)
* **Gestor de Escritorio / Iconos:** Nemo Desktop (`nemo-desktop`)
* **Reproductor de Fondo:** Hidamari v3.7 (vía Flatpak)

---

## 2. Instalación de Hidamari (Sin permisos de root / sudo)

Hidamari es una aplicación de código abierto desarrollada en Python/GTK que utiliza aceleración gráfica por hardware (VA-API / GPU) para reproducir videos locales, páginas web y streams como fondo de escritorio.

### A. Instalación de la aplicación a nivel de usuario
Se utilizó Flatpak con el repositorio Flathub apuntando únicamente al espacio de usuario (`--user`), evitando tocar archivos del sistema `/`:

```bash
flatpak install -y --user https://dl.flathub.org/repo/appstream/io.github.jeffshee.Hidamari.flatpakref
```

### B. Otorgar permisos de lectura al directorio personal
Por defecto, las aplicaciones Flatpak están enjauladas (sandbox). Se aplicó un override para que Hidamari pueda leer videos desde cualquier ruta del `$HOME`:

```bash
flatpak override --user --filesystem=home io.github.jeffshee.Hidamari
```
*(Este ajuste se almacena de forma persistente en `~/.local/share/flatpak/overrides/io.github.jeffshee.Hidamari`).*

---

## 3. Diagnóstico y Resolución del Bug de los Iconos Desaparecidos

### ¿Por qué desaparecen los iconos en Linux Mint Cinnamon?
En Cinnamon, los iconos del escritorio y los clics sobre el fondo los gestiona un proceso llamado `nemo-desktop`. El problema se debe a dos causas simultáneas:

#### Causa 1: `nemo-desktop` se cierra automáticamente
`nemo-desktop` tiene una comprobación de seguridad interna: si detecta otra ventana en el servidor gráfico clasificada como `_NET_WM_WINDOW_TYPE_DESKTOP`, asume que otro entorno de escritorio está gestionando la pantalla y **se apaga por completo** con este registro:
> `Nemo-WARNING: Desktop already managed by another application, skipping desktop setup. To change this, modify org.nemo.desktop 'ignored-desktop-handlers'.`

#### Causa 2: Orden de apilamiento en X11 (Z-Order)
Cuando Hidamari arranca, llama a la función `window.present()`. El gestor de ventanas Muffin apila la ventana del video **por encima** de la capa transparente de iconos de Nemo, dejándolos tapados físicamente detrás del video.

---

### Solución aplicada

#### 1. Agregar Hidamari a la lista blanca de Nemo (`ignored-desktop-handlers`)
Se modificó la configuración de Nemo en GSettings para que reconozca a Hidamari y no se cierre:

```bash
gsettings set org.nemo.desktop ignored-desktop-handlers "['conky', 'csd-background', 'hidamari', 'Hidamari', 'io.github.jeffshee.Hidamari']"
```

#### 2. Reordenar las capas de ventanas mediante `wmctrl`
Para traer los iconos al frente del video sin cerrar Hidamari, se fuerza el enfoque de la ventana del escritorio:

```bash
wmctrl -a "Escritorio"
```
*(En sistemas con idioma inglés el comando alternativo es `wmctrl -a "Desktop"`).*

---

## 4. Archivos y Scripts Implementados en el Sistema

### 1. Script auxiliar para traer los iconos al frente (`fix-icons`)
* **Ruta:** [`/home/greg/.local/bin/fix-icons`](file:///home/greg/.local/bin/fix-icons)
* **Permisos:** Ejecutable (`chmod +x`)
* **Código:**
```bash
#!/usr/bin/env bash

# Si nemo-desktop no está corriendo, iniciarlo de forma limpia
if ! pgrep -x "nemo-desktop" >/dev/null; then
    systemctl --user start nemo-desktop 2>/dev/null || nohup nemo-desktop >/dev/null 2>&1 &
    sleep 1
fi

# Traer la capa del escritorio al frente de la ventana del video
wmctrl -a "Escritorio" 2>/dev/null || wmctrl -a "Desktop" 2>/dev/null

notify-send -i preferences-desktop-wallpaper -u low "Live Wallpaper" "Desktop icons brought to front" 2>/dev/null
```

---

### 2. Script maestro de inicio y cambio de video (`start-animated-wallpaper.sh`)
* **Ruta:** [`/home/greg/.local/bin/start-animated-wallpaper.sh`](file:///home/greg/.local/bin/start-animated-wallpaper.sh)
* **Permisos:** Ejecutable (`chmod +x`)
* **Funcionalidad:**
  * Si se ejecuta solo, arranca el fondo configurado y acomoda los iconos.
  * Si se le pasa un archivo de video (`.mp4`, `.webm`, etc.) como parámetro, lo copia automáticamente a `~/Vídeos/Hidamari/`, actualiza el archivo de configuración, reinicia el reproductor y trae los iconos al frente.
* **Código:**
```bash
#!/usr/bin/env bash

CONFIG_FILE="$HOME/.var/app/io.github.jeffshee.Hidamari/config/hidamari/config.json"
TARGET_DIR="$HOME/Vídeos/Hidamari"

mkdir -p "$TARGET_DIR"

# Si el usuario pasó un video como argumento (ej: start-animated-wallpaper.sh video.mp4)
if [ -n "$1" ] && [ -f "$1" ]; then
    VIDEO_PATH="$(realpath "$1")"
    DEST_PATH="$TARGET_DIR/$(basename "$VIDEO_PATH")"
    
    # Si el video no está ya en la carpeta de Hidamari, copiarlo
    if [ "$VIDEO_PATH" != "$DEST_PATH" ]; then
        cp "$VIDEO_PATH" "$DEST_PATH"
    fi

    # Actualizar la ruta en el config.json de Hidamari
    python3 -c "
import json
cfg_path = '$CONFIG_FILE'
try:
    with open(cfg_path, 'r') as f:
        data = json.load(f)
except Exception:
    data = {'version': 4, 'mode': 'MODE_VIDEO', 'data_source': {}, 'is_mute': True}

data['mode'] = 'MODE_VIDEO'
data['data_source'] = {'Default': '$DEST_PATH', 'eDP-1': '$DEST_PATH'}
data['is_mute'] = True
data['is_pause_when_maximized'] = True

with open(cfg_path, 'w') as f:
    json.dump(data, f, indent=3)
"
fi

# Reiniciar o iniciar Hidamari a través de systemd user session
if systemctl --user is-active hidamari >/dev/null 2>&1; then
    systemctl --user restart hidamari
else
    pkill -f "io.github.jeffshee.Hidamari" 2>/dev/null
    systemd-run --user --unit=hidamari flatpak run --command=hidamari io.github.jeffshee.Hidamari -b 2>/dev/null || \
    setsid flatpak run --command=hidamari io.github.jeffshee.Hidamari -b >/dev/null 2>&1 &
fi

# Esperar a que la ventana de video se dibuje en pantalla
sleep 2.5

# Traer los iconos del escritorio al frente
~/.local/bin/fix-icons
```

---

### 3. Entrada de inicio automático al arrancar la PC (Autostart)
* **Ruta:** [`/home/greg/.config/autostart/io.github.jeffshee.Hidamari.desktop`](file:///home/greg/.config/autostart/io.github.jeffshee.Hidamari.desktop)
* **Contenido:**
```ini
[Desktop Entry]
Name=Hidamari Live Wallpaper
Exec=/home/greg/.local/bin/start-animated-wallpaper.sh
Icon=io.github.jeffshee.Hidamari
Terminal=false
Type=Application
Categories=GTK;Utility;
StartupNotify=false
X-GNOME-Autostart-enabled=true
```

---

### 4. Archivo de configuración interna de Hidamari
* **Ruta:** [`/home/greg/.var/app/io.github.jeffshee.Hidamari/config/hidamari/config.json`](file:///home/greg/.var/app/io.github.jeffshee.Hidamari/config/hidamari/config.json)
* **Ajustes clave:**
  * `mode`: `"MODE_VIDEO"`
  * `is_mute`: `true` (evita ruido constante de fondo)
  * `is_pause_when_maximized`: `true` (pausa la GPU/CPU al abrir ventanas a pantalla completa)

---

### 5. Carpeta central de videos
* **Ruta:** [`/home/greg/Vídeos/Hidamari/`](file:///home/greg/Vídeos/Hidamari/)
* Los videos se copian aquí para que no dependan de la carpeta `Descargas` si esta se vacía.

---

## 5. Guía de Uso Diario

### ¿Cómo cambiar el fondo fácilmente por terminal?
Solo ejecuta el script pasándole el video nuevo descargado:
```bash
start-animated-wallpaper.sh ~/Descargas/nuevo-fondo.mp4
```
*(El script copiará el video, actualizará la configuración, recargará el reproductor y dejará los iconos visibles).*

### ¿Qué hacer si cambias el fondo desde la ventana gráfica de Hidamari?
Si abres la interfaz gráfica de Hidamari y seleccionas un video a mano, la app recreará su ventana y volverá a tapar los iconos.  
Para arreglarlo inmediatamente, solo escribe en una terminal:
```bash
fix-icons
```

---

## 6. Procedimiento para Desinstalar o Revertir los Cambios

Si en algún momento deseas quitar completamente el fondo animado y volver al comportamiento estándar de Linux Mint:

```bash
# 1. Detener procesos
systemctl --user stop hidamari 2>/dev/null
pkill -f "io.github.jeffshee.Hidamari" 2>/dev/null

# 2. Eliminar inicio automático y scripts
rm -f ~/.config/autostart/io.github.jeffshee.Hidamari.desktop
rm -f ~/.local/bin/start-animated-wallpaper.sh
rm -f ~/.local/bin/fix-icons

# 3. Desinstalar la aplicación Flatpak y sus datos
flatpak uninstall -y --delete-data io.github.jeffshee.Hidamari

# 4. Restablecer la lista de manejadores ignorados en Nemo a su valor original
gsettings set org.nemo.desktop ignored-desktop-handlers "['conky', 'csd-background']"
```
