(use-modules
  (gnu)
  (gnu home)
  (gnu home services)
  (gnu home services dotfiles)
  (gnu home services fontutils)
  (gnu home services shells)
  (gnu packages admin)
  (gnu packages browser-extensions)
  (gnu packages chromium)
  (gnu packages education)
  (gnu packages emacs)
  (gnu packages fonts)
  (gnu packages freedesktop)
  (gnu packages gimp)
  (gnu packages gnome)
  (gnu packages gnome-circle)
  (gnu packages gnuzilla)
  (gnu packages image)
  (gnu packages image-viewers)
  (gnu packages imagemagick)
  (gnu packages inkscape)
  (gnu packages libreoffice)
  (gnu packages linux)
  (gnu packages package-management)
  (gnu packages pulseaudio)
  (gnu packages python)
  (gnu packages ssh)
  (gnu packages sync)
  (gnu packages tor-browsers)
  (gnu packages version-control)
  (gnu packages video)
  (gnu packages virtualization)
  (gnu packages xdisorg)
  (gnu packages xorg))
(home-environment
  (packages (list
    acpi
    adwaita-icon-theme
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
    gimp
    git
    hicolor-icon-theme
    htop
    icecat
    iftop
    imagemagick
    inkscape
    libreoffice
    mpv
    neofetch
    obs
    openboard
    openssh
    powertop
    pulseaudio
    python
    qemu
    rclone
    secrets
    setxkbmap
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
    xset))
  (services (list
    (service home-bash-service-type (home-bash-configuration
      (aliases '(("sudo" . "sudo --preserve-env=TERMINFO_DIRS")))))
   (service home-inputrc-service-type (home-inputrc-configuration
      (key-bindings `(
        ("\"\\eOd\"" . "backward-word")
        ("\"\\eOc\"" . "forward-word")))))
    (service home-dotfiles-service-type
      (home-dotfiles-configuration
        (directories '("../files"))))
    (simple-service 'my-env-vars-service home-environment-variables-service-type '(
      ("PATH" . "$HOME/.local/bin:$PATH")
      ("EDITOR" . "emacsclient")
      ("QT_QPA_PLATFORMTHEME" . "xdgdesktopportal")
      ("DOCKER_BUILDKIT" . "0")))
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

