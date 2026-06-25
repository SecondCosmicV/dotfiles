(use-modules
  (gnu)
  (gnu home services)
  (gnu home services dotfiles)
  (gnu home services fontutils)
  (gnu home services mpv)
  (gnu home services shells)
  (gnu packages admin)
  (gnu packages browser-extensions)
  (gnu packages chromium)
  (gnu packages commencement)
  (gnu packages compression)
  (gnu packages dns)
  (gnu packages education)
  (gnu packages emacs)
  (gnu packages emacs-xyz)
  (gnu packages fonts)
  (gnu packages freedesktop)
  (gnu packages gimp)
  (gnu packages gnome)
  (gnu packages gnome-circle)
  (gnu packages gnupg)
  (gnu packages gnuzilla)
  (gnu packages gtk)
  (gnu packages image)
  (gnu packages image-viewers)
  (gnu packages imagemagick)
  (gnu packages inkscape)
  (gnu packages libreoffice)
  (gnu packages linux)
  (gnu packages llvm)
  (gnu packages lxde)
  (gnu packages package-management)
  (gnu packages photo)
  (gnu packages polkit)
  (gnu packages pulseaudio)
  (gnu packages python)
  (gnu packages python-xyz)
  (gnu packages ssh)
  (gnu packages suckless)
  (gnu packages sync)
  (gnu packages tmux)
  (gnu packages tor-browsers)
  (gnu packages version-control)
  (gnu packages video)
  (gnu packages virtualization)
  (gnu packages wm)
  (gnu packages xdisorg)
  (gnu packages xorg)
  (nongnu packages messaging)
  (suika-chan packages docker-binary))
(home-environment
  (packages (list
    7zip
    acpi
    adwaita-icon-theme
    clang
    dconf
    dmenu
    docker-compose-binary
    dragon-drop
    efibootmgr
    emacs
    emacs-cape
    emacs-corfu
    emacs-dired-hacks
    emacs-dockerfile-mode
    emacs-magit
    emacs-multiple-cursors
    emacs-solarized-theme
    emacs-yaml-mode
    evince
    fastfetch
    feh
    ffmpeg
    flameshot
    font-dejavu
    font-google-noto
    font-google-noto-emoji
    font-google-noto-sans-cjk
    font-google-noto-sans-hebrew
    gcc-toolchain
    gimp
    git
    gnu-make
    gnupg
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
    ntfs-3g
    numlockx
    obs
    openboard
    openssh
    perl-image-exiftool
    pigz
    pinentry
    polkit-gnome
    powertop
    pulseaudio
    python
    python-lsp-server
    rclone
    secrets
    setxkbmap
    signal-desktop
    stow
    tmux
    torbrowser
    ublock-origin/chromium
    ungoogled-chromium
    virt-manager
    xclip
    xdg-desktop-portal-gtk
    xdg-utils
    xrandr
    xrdb
    xset
    (list isc-bind "utils")))
  (services (list
    (service home-files-service-type `(
      (".docker/cli-plugins/docker-compose" ,(symlink-to (file-append docker-compose-binary "/usr/lib/docker/cli-plugins/docker-compose")))))
    (service home-dotfiles-service-type (home-dotfiles-configuration
      (directories '("../files"))))
    (service home-mpv-service-type (make-home-mpv-configuration
      #:global (make-mpv-profile-configuration
        #:loop-file 'inf)))
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

