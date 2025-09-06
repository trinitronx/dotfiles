# Most pure GTK3 apps use wayland by default, but some,
# such as Firefox, require the backend to be explicitly selected.
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1
export GTK_CSD=0

# qt wayland
export QT_QPA_PLATFORM="wayland"
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

#Java XWayland blank screens fix
export _JAVA_AWT_WM_NONREPARENTING=1

# set ozone platform to wayland
export ELECTRON_OZONE_PLATFORM_HINT=wayland

# Disable hardware cursors. This might fix issues with
# disappearing cursors
if command -v systemd-detect-virt 1>/dev/null 2>&1 && systemd-detect-virt -q; then
    # if the system is running inside a virtual machine, disable hardware cursors
    export WLR_NO_HARDWARE_CURSORS=1
fi

