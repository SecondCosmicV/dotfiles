(use-modules
  (gnu)
  (gnu home services)
  (gnu home services dotfiles)
  (gnu home services fontutils)
  (gnu home services shells)
  (gnu packages admin)
  (gnu packages browser-extensions)
  (gnu packages chromium)
  (gnu packages commencement)
  (gnu packages compression)
  (gnu packages dns)
  (gnu packages education)
  (gnu packages emacs)
  (gnu packages fonts)
  (gnu packages freedesktop)
  (gnu packages gimp)
  (gnu packages gnome)
  (gnu packages gnome-circle)
  (gnu packages gnuzilla)
  (gnu packages gtk)
  (gnu packages image)
  (gnu packages image-viewers)
  (gnu packages imagemagick)
  (gnu packages inkscape)
  (gnu packages libreoffice)
  (gnu packages linux)
  (gnu packages lxde)
  (gnu packages package-management)
  (gnu packages polkit)
  (gnu packages pulseaudio)
  (gnu packages python)
  (gnu packages ssh)
  (gnu packages suckless)
  (gnu packages sync)
  (gnu packages tor-browsers)
  (gnu packages version-control)
  (gnu packages video)
  (gnu packages virtualization)
  (gnu packages wm)
  (gnu packages xdisorg)
  (gnu packages xorg))
(home-environment
  (packages (list
    7zip
    acpi
    adwaita-icon-theme
    dmenu
    dragon-drop
    efibootmgr
    emacs
    evince
    feh
    ffmpeg
    flameshot
    flatpak
    font-dejavu
    font-google-noto
    font-google-noto-emoji
    font-google-noto-sans-cjk
    font-google-noto-sans-hebrew
    gcc-toolchain
    gimp
    git
    gnu-make
    hicolor-icon-theme
    htop
    i3-wm
    icecat
    iftop
    imagemagick
    inkscape
    libreoffice
    lm-sensors
    lxterminal
    mpv
    neofetch
    numlockx
    obs
    openboard
    openssh
    polkit-gnome
    powertop
    pulseaudio
    python
    qemu
    rclone
    secrets
    setxkbmap
    stow
    torbrowser
    ublock-origin/chromium
    ungoogled-chromium
    virt-manager
    xclip
    xdg-desktop-portal-gtk
    xdg-utils
    xinit
    xrandr
    xrdb
    xset
    (list isc-bind "utils")))
  (services (list
    (service home-dotfiles-service-type (home-dotfiles-configuration
      (directories '("../files"))))
    (simple-service 'my-env-vars-service home-environment-variables-service-type '(
      ("PATH" . "$HOME/.local/bin:$PATH")
      ("EDITOR" . "nano")
      ("DOCKER_BUILDKIT" . "0")
      ("QT_QPA_PLATFORMTHEME" . "xdgdesktopportal")))
    (simple-service 'my-profile-service home-shell-profile-service-type (list
      (plain-file "my-profile" "if [ \"$(tty)\" = \"/dev/tty1\" ]; then exec startx; fi")))
    (simple-service 'my-fontconfig-service home-fontconfig-service-type (list
      '(alias
        (family "serif")
        (prefer (family "DejaVu Serif")))
      '(alias
        (family "sans-serif")
        (prefer (family "DejaVu Sans")))
      '(alias
        (family "monospace")
        (prefer (family "DejaVu Sans Mono"))))))))

