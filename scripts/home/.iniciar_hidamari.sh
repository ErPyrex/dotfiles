#!/bin/bash
# Matar cualquier instancia previa del daemon para evitar duplicados
pkill -f daemon_hidamari.sh

# Iniciar el daemon en segundo plano
nohup $HOME/.daemon_hidamari.sh >/dev/null 2>&1 &

# Iniciar Hidamari en segundo plano desvinculado de la terminal
nohup flatpak run io.github.jeffshee.Hidamari >/dev/null 2>&1 &

# Esperar 5 segundos a que la ventana de Hidamari se abra por completo
sleep 5

# Reiniciar nemo-desktop para forzar los iconos a dibujarse sobre el video
pkill nemo-desktop
sleep 1
nohup nemo-desktop >/dev/null 2>&1 &
