# ⚙️ Dotfiles & Linux Setup

Repositorio centralizado de configuraciones, dotfiles, scripts de automatización y temas para mi entorno Linux (Linux Mint 22.3 Cinnamon / Ubuntu / Debian).

Incluye un script bash automatizado (`install.sh`) que permite replicar e instalar todo el entorno desde cero en una máquina nueva con un solo comando.

---

## 🚀 Instalación Rápida

Para clonar y desplegar las configuraciones en un sistema nuevo:

```bash
git clone https://github.com/ErPyrex/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### ⚡ Modo Automático (Desatendido)
Si deseas instalar todo automáticamente sin confirmaciones interactivas:
```bash
./install.sh -y
```

### 🛠️ Opciones Disponibles

| Opción | Descripción |
|---|---|
| `-y`, `--all` | Instalación completa no interactiva (responde 'sí' a todo). |
| `--symlink` | Crea enlaces simbólicos en lugar de copiar los archivos (útil si desarrollas en el repo). |
| `--no-packages` | Omite la instalación de paquetes con APT (útil si ya tienes todo instalado). |
| `--no-cinnamon` | Omite la restauración de la configuración de dconf de Cinnamon y Nemo. |
| `--no-vscode` | Omite la instalación de extensiones de VS Code. |
| `-h`, `--help` | Muestra la ayuda en terminal. |

---

## 🛡️ Seguridad y Respaldo Automático

Antes de sobrescribir cualquier archivo existente en tu `$HOME` o `~/.config/`, el instalador creará una copia de seguridad organizada en:

```
~/.dotfiles_backup_YYYYMMDD_HHMMSS/
```

Nada se pierde ni se sobrescribe sin respaldo previo.

---

## 📦 Estructura del Repositorio

```text
dotfiles/
├── .bashrc                         # Configuración de Bash con aliases y variables
├── .zshrc                          # Configuración de ZSH con Oh-My-Zsh, plugins y aliases
├── .zshenv                         # Variables de entorno ZSH (Cargo, etc.)
├── .zprofile                       # Perfil de inicio ZSH
├── .gitconfig                      # Configuración global de Git
├── install.sh                      # Script instalador automatizado
│
├── .config/                        # Configuraciones de aplicaciones (~/.config)
│   ├── kitty/                      # Terminal Kitty (tema Catppuccin Macchiato, atajos)
│   ├── fastfetch/                  # Información del sistema con logo/imagen personalizada
│   ├── nvim/                       # Neovim (configuración moderna modular en Lua)
│   ├── rofi/                       # Lanzador Rofi (applets, lanzadores, powermenu)
│   ├── btop/                       # Monitor del sistema TUI
│   ├── cava/                       # Visualizador de audio reactivo
│   ├── lazygit/                    # Interfaz de Git para terminal
│   ├── lazydocker/                 # Interfaz de Docker para terminal
│   ├── autostart/                  # Accesos directos de inicio automático
│   └── Code/User/                  # Configuración de Visual Studio Code
│
├── scripts/                        # Scripts personalizados
│   ├── home/                       # Scripts ubicados en $HOME (Hidamari, daemons de escritorio)
│   └── bin/                        # Scripts ejecutables en ~/.local/bin (ani-cli-mx, etc.)
│
├── cinnamon/                       # Backups de configuraciones de entorno de escritorio
│   ├── cinnamon-backup.dconf       # Paneles, atajos, applets y temas de Cinnamon
│   └── nemo-backup.dconf           # Preferencias y gestores de escritorio Nemo
│
├── fonts/                          # Fuentes tipográficas y Nerd Fonts
│   ├── user/                       # Fuentes para ~/.fonts
│   └── local-share/                # FiraMono Nerd Font, JetBrains Mono, etc. (~/.local/share/fonts)
│
├── themes/                         # Temas GTK (~/.themes: Orchis, Adapta-Nokto)
├── icons/                          # Iconos y cursores (~/.icons: Bibata-Modern-Ice)
├── wallpapers/                     # Fondos de pantalla incluidos
└── vscode/                         # Lista de extensiones de VS Code (extensions.txt)
```

---

## ⌨️ Atajos de Teclado Principales (Cinnamon)

| Atajo | Acción |
|---|---|
| <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd> | Abrir terminal **Kitty** |
| <kbd>Super</kbd> + <kbd>Espacio</kbd> | Abrir lanzador **Rofi** |
| <kbd>Print</kbd> | Captura de pantalla con **Flameshot** |

---

## 💻 Atajos en Terminal Kitty

- <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Enter</kbd> : Nueva pestaña con mismo directorio de trabajo
- <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd> : Nueva ventana con mismo directorio de trabajo
- <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Z</kbd> : Maximizar / Zoom en ventana actual (toggle stack)
- <kbd>Ctrl</kbd> + <kbd>Flechas</kbd> : Navegación entre ventanas
