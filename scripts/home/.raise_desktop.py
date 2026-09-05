import ctypes
import subprocess
import re

def get_window_id(class_name):
    try:
        out = subprocess.check_output(['wmctrl', '-l', '-x']).decode('utf-8')
        for line in out.splitlines():
            if class_name in line:
                match = re.search(r'(0x[0-9a-fA-F]+)', line)
                if match:
                    return int(match.group(1), 16)
    except Exception:
        pass
    return None

def main():
    x11 = ctypes.cdll.LoadLibrary('libX11.so.6')
    x11.XOpenDisplay.restype = ctypes.c_void_p
    x11.XRaiseWindow.argtypes = [ctypes.c_void_p, ctypes.c_ulong]
    x11.XLowerWindow.argtypes = [ctypes.c_void_p, ctypes.c_ulong]
    
    display = x11.XOpenDisplay(None)
    if not display:
        return
        
    # Buscar nemo-desktop
    nemo_wid = get_window_id('nemo-desktop.Nemo-desktop')
    
    # Buscar la ventana de video de hidamari (clase hidamari.Hidamari y título exacto "hidamari" en minúscula)
    hidamari_wid = None
    try:
        out = subprocess.check_output(['wmctrl', '-l', '-x']).decode('utf-8')
        for line in out.splitlines():
            parts = line.split(None, 4)
            if len(parts) >= 5:
                wid_str, _, win_class, _, win_title = parts
                if win_class == 'hidamari.Hidamari' and win_title == 'hidamari':
                    hidamari_wid = int(wid_str, 16)
    except Exception:
        pass
        
    if hidamari_wid:
        # Mandar hidamari al fondo
        x11.XLowerWindow(display, hidamari_wid)
        
    if nemo_wid:
        # Traer nemo-desktop al frente
        x11.XRaiseWindow(display, nemo_wid)
        
    x11.XCloseDisplay(display)

if __name__ == '__main__':
    main()
