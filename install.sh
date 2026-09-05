#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Installer & System Setup Script
# Autor: ErPyrex (Sergio Alarcón)
# Compatible con: Linux Mint, Ubuntu, Debian y derivados
# ==============================================================================

set -euo pipefail

# Colores para salida por terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # Sin color

# Rutas principales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DATE="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$HOME/.dotfiles_backup_${BACKUP_DATE}"

# Opciones por defecto
NON_INTERACTIVE=false
SKIP_PACKAGES=false
SKIP_CINNAMON=false
SKIP_VSCODE=false
USE_SYMLINK=false

# Mensajes de logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "\n${BOLD}${CYAN}==> $1${NC}"
}

# Verificación de usuario
if [[ $EUID -eq 0 ]]; then
    log_error "Este script NO debe ejecutarse como root (con sudo)."
    log_info "Ejecútalo como tu usuario habitual ($USER). Se te pedirá la contraseña de sudo cuando sea necesario."
    exit 1
fi

# Ayuda y uso
show_help() {
    echo -e "${BOLD}Uso:${NC} ./install.sh [OPCIONES]

${BOLD}Opciones:${NC}
  -y, --all           Instalación completa no interactiva (responde 'sí' a todo).
  --no-packages       Omite la instalación de paquetes del sistema (APT / Git / etc).
  --no-cinnamon       Omite la restauración de la configuración de Cinnamon y Nemo (dconf).
  --no-vscode         Omite la instalación de extensiones de VS Code.
  --symlink           Crea enlaces simbólicos (symlinks) en lugar de copiar los archivos.
  -h, --help          Muestra esta ayuda.

${BOLD}Por defecto:${NC}
  El script funciona de manera interactiva, preguntándote cada paso y realizando
  una copia segura de tus configuraciones con respaldo previo en:
  ~/.dotfiles_backup_YYYYMMDD_HHMMSS/"
}

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--all)
            NON_INTERACTIVE=true
            shift
            ;;
        --no-packages)
            SKIP_PACKAGES=true
            shift
            ;;
        --no-cinnamon)
            SKIP_CINNAMON=true
            shift
            ;;
        --no-vscode)
            SKIP_VSCODE=true
            shift
            ;;
        --symlink)
            USE_SYMLINK=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            log_error "Opción desconocida: $1"
            show_help
            exit 1
            ;;
    esac
done

# Función de confirmación interactiva
ask_confirmation() {
    local prompt="$1"
    local default_resp="${2:-Y}"
    
    if [[ "$NON_INTERACTIVE" == true ]]; then
        return 0
    fi

    if [[ "$default_resp" =~ ^[YySs] ]]; then
        prompt="$prompt [S/n]: "
    else
        prompt="$prompt [s/N]: "
    fi

    read -r -p "$(echo -e "${YELLOW}$prompt${NC}")" response
    response="${response:-$default_resp}"

    if [[ "$response" =~ ^[sSyY]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Función para respaldar y copiar/enlazar archivos o directorios
backup_and_deploy() {
    local src="$1"
    local dest="$2"

    if [[ ! -e "$src" ]]; then
        log_warn "El origen '$src' no existe. Omitiendo..."
        return 0
    fi

    # Si el destino existe o es enlace simbólico roto
    if [[ -e "$dest" || -L "$dest" ]]; then
        mkdir -p "$BACKUP_DIR"
        # Calcular ruta relativa dentro del backup
        local rel_path
        if [[ "$dest" == "$HOME"* ]]; then
            rel_path="${dest#$HOME/}"
        else
            rel_path="$(basename "$dest")"
        fi
        
        local target_backup_dir
        target_backup_dir="$BACKUP_DIR/$(dirname "$rel_path")"
        mkdir -p "$target_backup_dir"
        
        cp -rP "$dest" "$BACKUP_DIR/$rel_path"
        log_info "Respaldado: $dest -> $BACKUP_DIR/$rel_path"
        rm -rf "$dest"
    fi

    mkdir -p "$(dirname "$dest")"

    if [[ "$USE_SYMLINK" == true ]]; then
        ln -sfn "$src" "$dest"
        log_success "Enlace simbólico creado: $dest -> $src"
    else
        cp -rP "$src" "$dest"
        log_success "Instalado: $dest"
    fi
}

# ==============================================================================
# INICIO DE LA INSTALACIÓN
# ==============================================================================
clear
echo -e "${BOLD}${CYAN}"
echo "  ____        _    __ _ _             ___           _        _ _           "
echo " |  _ \  ___ | |_ / _(_) | ___  ___  |_ _|_ __  ___| |_ __ _| | | ___ _ __ "
echo " | | | |/ _ \| __| |_| | |/ _ \/ __|  | || '_ \/ __| __/ _\` | | |/ _ \ '__|"
echo " | |_| | (_) | |_|  _| | |  __/\__ \  | || | | \__ \ || (_| | | |  __/ |   "
echo " |____/ \___/ \__|_| |_|_|\___||___/ |___|_| |_|___/\__\__,_|_|_|\___|_|   "
echo -e "${NC}"
echo -e "Repositorio: ${BOLD}ErPyrex/dotfiles${NC}"
echo -e "Modo: $(if [[ "$USE_SYMLINK" == true ]]; then echo -e "${MAGENTA}Enlaces Simbólicos${NC}"; else echo -e "${GREEN}Copia directa con Respaldo Seguro (.bak)${NC}"; fi)"
echo -e "Directorio de trabajo: ${BLUE}$SCRIPT_DIR${NC}\n"

# ------------------------------------------------------------------------------
# 1. PAQUETES DEL SISTEMA
# ------------------------------------------------------------------------------
if [[ "$SKIP_PACKAGES" == false ]]; then
    if ask_confirmation "¿Deseas actualizar los repositorios e instalar los paquetes esenciales (APT)?" "Y"; then
        log_step "Instalando paquetes del sistema mediante APT..."
        sudo apt update

        PACKAGES=(
            build-essential
            curl
            wget
            git
            zsh
            bat
            lsd
            fzf
            btop
            cava
            rofi
            flameshot
            wmctrl
            neovim
            flatpak
            dconf-cli
            python3
            unzip
            fontconfig
        )

        log_info "Instalando paquetes: ${PACKAGES[*]}"
        sudo apt install -y "${PACKAGES[@]}"

        # Fix de 'bat' en distribuciones Debian/Ubuntu/Mint
        if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
            log_info "Creando alias/symlink para batcat -> ~/.local/bin/bat"
            mkdir -p "$HOME/.local/bin"
            ln -sfn "$(which batcat)" "$HOME/.local/bin/bat"
        fi

        log_success "Paquetes esenciales de APT instalados correctamente."
    else
        log_info "Instalación de paquetes omitida por el usuario."
    fi
fi

# ------------------------------------------------------------------------------
# 2. OH MY ZSH Y PLUGINS
# ------------------------------------------------------------------------------
if ask_confirmation "¿Deseas configurar Oh My Zsh y los plugins (syntax-highlighting, autosuggestions)?" "Y"; then
    log_step "Configurando Oh My Zsh y plugins..."
    
    # Instalar Oh My Zsh si no existe
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Instalando Oh My Zsh..."
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" || true
        log_success "Oh My Zsh instalado."
    else
        log_info "Oh My Zsh ya se encuentra instalado."
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    mkdir -p "$ZSH_CUSTOM/plugins"

    # zsh-syntax-highlighting
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        log_info "Clonando zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    else
        log_info "Actualizando zsh-syntax-highlighting..."
        git -C "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" pull || true
    fi

    # zsh-autosuggestions
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        log_info "Clonando zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    else
        log_info "Actualizando zsh-autosuggestions..."
        git -C "$ZSH_CUSTOM/plugins/zsh-autosuggestions" pull || true
    fi

    log_success "Oh My Zsh y plugins listos."
fi

# ------------------------------------------------------------------------------
# 3. TERMINAL KITTY
# ------------------------------------------------------------------------------
if ! command -v kitty &>/dev/null && [[ ! -f "$HOME/.local/bin/kitty" ]]; then
    if ask_confirmation "¿Kitty no está detectado. Deseas instalarlo mediante su instalador oficial?" "Y"; then
        log_step "Instalando Kitty terminal..."
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        
        mkdir -p "$HOME/.local/bin"
        ln -sfn "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
        ln -sfn "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"
        
        # Desktop integration
        mkdir -p "$HOME/.local/share/applications"
        cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/" 2>/dev/null || true
        cp "$HOME/.local/kitty.app/share/applications/kitty-open.desktop" "$HOME/.local/share/applications/" 2>/dev/null || true
        sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "$HOME/.local/share/applications/kitty*.desktop" 2>/dev/null || true
        sed -i "s|Exec=kitty|Exec=$HOME/.local/kitty.app/bin/kitty|g" "$HOME/.local/share/applications/kitty*.desktop" 2>/dev/null || true
        
        log_success "Kitty terminal instalado con éxito."
    fi
fi

# ------------------------------------------------------------------------------
# 4. LAZYGIT Y LAZYDOCKER
# ------------------------------------------------------------------------------
if ! command -v lazygit &>/dev/null; then
    if ask_confirmation "¿Deseas instalar LazyGit?" "Y"; then
        log_step "Instalando LazyGit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') || LAZYGIT_VERSION="0.48.0"
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        mkdir -p /tmp/lazygit_temp
        tar xf /tmp/lazygit.tar.gz -C /tmp/lazygit_temp
        sudo install /tmp/lazygit_temp/lazygit /usr/local/bin
        rm -rf /tmp/lazygit.tar.gz /tmp/lazygit_temp
        log_success "LazyGit instalado."
    fi
fi

if ! command -v lazydocker &>/dev/null && [[ ! -f "$HOME/.local/bin/lazydocker" ]]; then
    if ask_confirmation "¿Deseas instalar LazyDocker?" "Y"; then
        log_step "Instalando LazyDocker..."
        curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
        log_success "LazyDocker instalado."
    fi
fi

# ------------------------------------------------------------------------------
# 5. DOTFILES Y CONFIGURACIONES (.config & HOME)
# ------------------------------------------------------------------------------
if ask_confirmation "¿Deseas aplicar las configuraciones de Shell (.zshrc, .bashrc, .zshenv, .zprofile)?" "Y"; then
    log_step "Instalando archivos de configuración en HOME..."
    backup_and_deploy "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
    backup_and_deploy "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
    backup_and_deploy "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"
    backup_and_deploy "$SCRIPT_DIR/.zprofile" "$HOME/.zprofile"

    # Git config
    if ask_confirmation "¿Deseas aplicar el archivo .gitconfig incluido (Usuario: ErPyrex)?" "Y"; then
        backup_and_deploy "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
    else
        log_info "Se omitió la sobreescritura de .gitconfig."
    fi
fi

if ask_confirmation "¿Deseas aplicar las configuraciones de aplicaciones (.config: Kitty, Fastfetch, Neovim, Rofi, Cava, Btop, etc.)?" "Y"; then
    log_step "Instalando configuraciones en ~/.config..."
    
    # Kitty
    backup_and_deploy "$SCRIPT_DIR/.config/kitty" "$HOME/.config/kitty"
    
    # Fastfetch
    backup_and_deploy "$SCRIPT_DIR/.config/fastfetch" "$HOME/.config/fastfetch"
    
    # Neovim
    backup_and_deploy "$SCRIPT_DIR/.config/nvim" "$HOME/.config/nvim"
    
    # Rofi
    backup_and_deploy "$SCRIPT_DIR/.config/rofi" "$HOME/.config/rofi"
    
    # Cava
    backup_and_deploy "$SCRIPT_DIR/.config/cava" "$HOME/.config/cava"
    
    # Btop
    backup_and_deploy "$SCRIPT_DIR/.config/btop" "$HOME/.config/btop"
    
    # Lazygit & Lazydocker
    backup_and_deploy "$SCRIPT_DIR/.config/lazygit" "$HOME/.config/lazygit"
    backup_and_deploy "$SCRIPT_DIR/.config/lazydocker" "$HOME/.config/lazydocker"
    
    # VS Code settings
    if [[ -f "$SCRIPT_DIR/.config/Code/User/settings.json" ]]; then
        mkdir -p "$HOME/.config/Code/User"
        backup_and_deploy "$SCRIPT_DIR/.config/Code/User/settings.json" "$HOME/.config/Code/User/settings.json"
    fi

    # Autostart
    if [[ -d "$SCRIPT_DIR/.config/autostart" ]]; then
        mkdir -p "$HOME/.config/autostart"
        for desktop_file in "$SCRIPT_DIR/.config/autostart"/*.desktop; do
            if [[ -f "$desktop_file" ]]; then
                fname="$(basename "$desktop_file")"
                # Adaptar la ruta de HOME para que apunte al usuario actual
                sed "s|\$HOME|$HOME|g; s|/home/pyrex64|$HOME|g" "$desktop_file" > "/tmp/$fname"
                backup_and_deploy "/tmp/$fname" "$HOME/.config/autostart/$fname"
                rm -f "/tmp/$fname"
            fi
        done
    fi
fi

# ------------------------------------------------------------------------------
# 6. FUENTES, TEMAS E ICONOS
# ------------------------------------------------------------------------------
if ask_confirmation "¿Deseas instalar las fuentes (FiraMono Nerd Font, JetBrains Mono, etc.)?" "Y"; then
    log_step "Instalando fuentes..."
    mkdir -p "$HOME/.fonts"
    mkdir -p "$HOME/.local/share/fonts"
    
    if [[ -d "$SCRIPT_DIR/fonts/user" ]]; then
        cp -rf "$SCRIPT_DIR/fonts/user"/* "$HOME/.fonts/" 2>/dev/null || true
    fi
    if [[ -d "$SCRIPT_DIR/fonts/local-share" ]]; then
        cp -rf "$SCRIPT_DIR/fonts/local-share"/* "$HOME/.local/share/fonts/" 2>/dev/null || true
    fi
    
    log_info "Actualizando caché de fuentes del sistema (fc-cache)..."
    fc-cache -fv &>/dev/null || true
    log_success "Fuentes instaladas y caché actualizado."
fi

if ask_confirmation "¿Deseas instalar los temas (~/.themes: Orchis, Adapta) e iconos (~/.icons: Bibata-Modern-Ice)?" "Y"; then
    log_step "Instalando temas e iconos..."
    mkdir -p "$HOME/.themes" "$HOME/.icons"
    
    if [[ -d "$SCRIPT_DIR/themes" ]]; then
        cp -rf "$SCRIPT_DIR/themes"/* "$HOME/.themes/" 2>/dev/null || true
        log_success "Temas instalados en ~/.themes."
    fi
    
    if [[ -d "$SCRIPT_DIR/icons" ]]; then
        cp -rf "$SCRIPT_DIR/icons"/* "$HOME/.icons/" 2>/dev/null || true
        log_success "Iconos instalados en ~/.icons."
    fi
fi

# ------------------------------------------------------------------------------
# 7. FONDO DE PANTALLA
# ------------------------------------------------------------------------------
if [[ -d "$SCRIPT_DIR/wallpapers" ]]; then
    if ask_confirmation "¿Deseas copiar el fondo de pantalla en ~/Imágenes?" "Y"; then
        log_step "Instalando fondos de pantalla..."
        mkdir -p "$HOME/Imágenes"
        cp -rf "$SCRIPT_DIR/wallpapers"/* "$HOME/Imágenes/" 2>/dev/null || true
        log_success "Fondos copiados en $HOME/Imágenes/."
    fi
fi

# ------------------------------------------------------------------------------
# 8. SCRIPTS PERSONALIZADOS Y AUTOMATIZACIONES
# ------------------------------------------------------------------------------
if ask_confirmation "¿Deseas instalar los scripts personalizados (fondos animados, daemon Hidamari, ani-cli-mx)?" "Y"; then
    log_step "Instalando scripts personalizados..."
    
    # Scripts en HOME
    if [[ -d "$SCRIPT_DIR/scripts/home" ]]; then
        for script_file in "$SCRIPT_DIR/scripts/home"/* "$SCRIPT_DIR/scripts/home"/.*; do
            [[ ! -e "$script_file" ]] && continue
            fname="$(basename "$script_file")"
            [[ "$fname" == "." || "$fname" == ".." || "$fname" == "*" ]] && continue
            
            # Adaptar rutas al HOME del usuario actual
            sed "s|\$HOME|$HOME|g; s|/home/pyrex64|$HOME|g" "$script_file" > "/tmp/$fname"
            backup_and_deploy "/tmp/$fname" "$HOME/$fname"
            chmod +x "$HOME/$fname"
            rm -f "/tmp/$fname"
        done
        log_success "Scripts de HOME instalados y permisos de ejecución otorgados."
    fi

    # Scripts en ~/.local/bin
    if [[ -d "$SCRIPT_DIR/scripts/bin" ]]; then
        mkdir -p "$HOME/.local/bin"
        for bin_file in "$SCRIPT_DIR/scripts/bin"/*; do
            if [[ -f "$bin_file" ]]; then
                fname="$(basename "$bin_file")"
                backup_and_deploy "$bin_file" "$HOME/.local/bin/$fname"
                chmod +x "$HOME/.local/bin/$fname"
            fi
        done
        log_success "Scripts ejecutables instalados en ~/.local/bin/."
    fi
fi

# ------------------------------------------------------------------------------
# 9. EXTENSIONES DE VS CODE
# ------------------------------------------------------------------------------
if [[ "$SKIP_VSCODE" == false && -f "$SCRIPT_DIR/vscode/extensions.txt" ]] && command -v code &>/dev/null; then
    if ask_confirmation "¿Deseas instalar las extensiones de VS Code listadas en vscode/extensions.txt?" "Y"; then
        log_step "Instalando extensiones de Visual Studio Code..."
        while IFS= read -r ext || [[ -n "$ext" ]]; do
            ext="$(echo "$ext" | tr -d '\r' | xargs)"
            [[ -z "$ext" ]] && continue
            log_info "Instalando extensión: $ext"
            code --install-extension "$ext" --force || true
        done < "$SCRIPT_DIR/vscode/extensions.txt"
        log_success "Extensiones de VS Code instaladas."
    fi
fi

# ------------------------------------------------------------------------------
# 10. CINNAMON & NEMO (dconf)
# ------------------------------------------------------------------------------
if [[ "$SKIP_CINNAMON" == false ]] && command -v dconf &>/dev/null; then
    if ask_confirmation "¿Deseas restaurar la configuración de Cinnamon (paneles, atajos de teclado, applets) y Nemo?" "Y"; then
        log_step "Restaurando configuraciones de Cinnamon y Nemo..."
        
        if [[ -f "$SCRIPT_DIR/cinnamon/cinnamon-backup.dconf" ]]; then
            # Crear versión adaptada reemplazando /home/pyrex64 con $HOME
            sed "s|/home/pyrex64|$HOME|g" "$SCRIPT_DIR/cinnamon/cinnamon-backup.dconf" > /tmp/cinnamon-restore.dconf
            dconf load /org/cinnamon/ < /tmp/cinnamon-restore.dconf
            rm -f /tmp/cinnamon-restore.dconf
            log_success "Configuración de Cinnamon aplicada."
        fi

        if [[ -f "$SCRIPT_DIR/cinnamon/nemo-backup.dconf" ]]; then
            dconf load /org/nemo/ < "$SCRIPT_DIR/cinnamon/nemo-backup.dconf"
            log_success "Configuración de Nemo aplicada."
        fi
    fi
fi

# ------------------------------------------------------------------------------
# 11. CAMBIAR SHELL POR DEFECTO A ZSH
# ------------------------------------------------------------------------------
if command -v zsh &>/dev/null; then
    CURRENT_SHELL="$(basename "$SHELL")"
    if [[ "$CURRENT_SHELL" != "zsh" ]]; then
        if ask_confirmation "¿Deseas configurar Zsh como tu shell por defecto?" "Y"; then
            log_step "Cambiando shell por defecto a Zsh..."
            chsh -s "$(which zsh)" "$USER"
            log_success "Shell cambiado a Zsh (se aplicará en tu próximo inicio de sesión)."
        fi
    fi
fi

# ------------------------------------------------------------------------------
# RESUMEN FINAL
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${GREEN}================================================================${NC}"
echo -e "${BOLD}${GREEN}          ¡INSTALACIÓN COMPLETADA CON ÉXITO!                     ${NC}"
echo -e "${BOLD}${GREEN}================================================================${NC}"

if [[ -d "$BACKUP_DIR" ]]; then
    echo -e "\n${YELLOW}Tus archivos previos fueron respaldados de manera segura en:${NC}"
    echo -e "  ${BOLD}$BACKUP_DIR${NC}"
fi

echo -e "\n${BOLD}Siguientes pasos recomendados:${NC}"
echo -e "  1. Reinicia tu sesión o recarga tu shell: ${CYAN}exec zsh${NC}"
echo -e "  2. Abre ${CYAN}Kitty${NC} con el atajo: ${BOLD}Ctrl + Alt + T${NC}"
echo -e "  3. Abre el lanzador ${CYAN}Rofi${NC} con el atajo: ${BOLD}Super + Espacio${NC}"
echo -e "  4. Disfruta de tu entorno configurado."
echo -e ""
