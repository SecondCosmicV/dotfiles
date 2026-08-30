(use-modules
  (gnu)
  (gnu home services)
  (gnu home services dotfiles)
  (gnu home services fontutils)
  (gnu home services gnupg)
  (gnu home services mpv)
  (gnu home services shells)
  (gnu packages admin)
  (gnu packages bittorrent)
  (gnu packages browser-extensions)
  (gnu packages chromium)
  (gnu packages commencement)
  (gnu packages compression)
  (gnu packages curl)
  (gnu packages dns)
  (gnu packages education)
  (gnu packages fonts)
  (gnu packages freedesktop)
  (gnu packages gimp)
  (gnu packages gnome)
  (gnu packages gnome-circle)
  (gnu packages gnupg)
  (gnu packages gnuzilla)
  (gnu packages image)
  (gnu packages image-viewers)
  (gnu packages imagemagick)
  (gnu packages inkscape)
  (gnu packages libreoffice)
  (gnu packages linux)
  (gnu packages lisp)
  (gnu packages lisp-xyz)
  (gnu packages lxde)
  (gnu packages networking)
  (gnu packages package-management)
  (gnu packages pdf)
  (gnu packages photo)
  (gnu packages polkit)
  (gnu packages pulseaudio)
  (gnu packages python)
  (gnu packages python-web)
  (gnu packages rsync)
  (gnu packages ssh)
  (gnu packages suckless)
  (gnu packages sync)
  (gnu packages tmux)
  (gnu packages tor-browsers)
  (gnu packages version-control)
  (gnu packages video)
  (gnu packages virtualization)
  (gnu packages window-management)
  (gnu packages xdisorg)
  (gnu packages xfce)
  (gnu packages xorg)
  (nongnu packages messaging)
  (nongnu packages mozilla)
  (suika-chan packages guix-infra))
(home-environment
  (packages (list
    7zip
    acpi
    adwaita-icon-theme
    curl
    dconf
    dmenu
    efibootmgr
    evince
    fastfetch
    feh
    ffmpeg
    firefox-esr
    flameshot
    font-dejavu
    font-google-noto
    font-google-noto-emoji
    font-google-noto-sans-cjk
    font-google-noto-sans-hebrew
    gcc-toolchain
    gedit
    gimp
    git
    git-lfs
    gnu-make
    gnupg
    guix-infra
    hicolor-icon-theme
    htop
    i3-wm
    icedove
    iftop
    imagemagick
    inkscape
    libreoffice
    lm-sensors
    lxterminal
    mpv
    nmap
    ntfs-3g
    numlockx
    obs
    openboard
    openssh
    pcmanfm
    perl-image-exiftool
    pigz
    pinentry
    polkit-gnome
    poppler
    powertop
    pulseaudio
    python-huggingface-hub
    python-wrapper
    qbittorrent
    rclone
    ristretto
    rsync
    sbcl
    sbcl-cl-ppcre
    sbcl-local-time
    secrets
    setxkbmap
    signal-desktop
    stow
    tmux
    torbrowser
    tumbler
    ublock-origin/chromium
    ungoogled-chromium
    virt-manager
    wireshark
    xclip
    xdg-desktop-portal-gtk
    xdg-utils
    xrandr
    xrdb
    xset
    (list isc-bind "utils")))
  (services (list
    (service home-dotfiles-service-type (home-dotfiles-configuration
      (directories '("../files"))))
    (service home-gpg-agent-service-type (home-gpg-agent-configuration
      (pinentry-program (file-append pinentry "/bin/pinentry"))))
    (service home-mpv-service-type (make-home-mpv-configuration
      #:global (make-mpv-profile-configuration
        #:loop-file 'inf)))
    (simple-service 'my-env-vars-service home-environment-variables-service-type '(
      ("EDITOR" . "nano")
      ("LC_COLLATE" . "C")
      ("PATH" . "$HOME/.local/bin:$PATH")
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

