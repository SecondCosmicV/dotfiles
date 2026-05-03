(use-modules
  (srfi srfi-1)
  (gnu)
  (gnu packages cryptsetup)
  (gnu packages linux)
  (gnu packages suckless)
  (gnu packages wm)
  (gnu packages xdisorg)
  (gnu services desktop)
  (gnu services docker)
  (gnu services shepherd)
  (gnu services virtualization)
  (gnu services xorg)
  (nongnu packages linux)
  (nongnu system linux-initrd))
(operating-system
  (kernel linux)
  (kernel-arguments (cons
    "ipv6.disable=1"
    %default-kernel-arguments))
  (initrd microcode-initrd)
  (firmware (cons
    iwlwifi-firmware
    %base-firmware))
  (locale "de_DE.utf8")
  (timezone "Europe/Berlin")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "plt318")
  (users (cons
    (user-account
      (name "peter")
      (group "users")
      (supplementary-groups '(
        "audio"
        "docker"
        "kvm"
        "libvirt"
        "netdev"
        "video"
        "wheel")))
    %base-user-accounts))
  (packages (append
    (list
      brightnessctl
      cryptsetup
      dmenu
      i3-wm
      iptables
      rxvt-unicode)
    %base-packages))
  (services (cons*
    (service xorg-server-service-type)
    (service libvirt-service-type)
    (service virtlog-service-type)
    (service containerd-service-type)
    (service docker-service-type)
    (simple-service 'my-service shepherd-root-service-type (list
      (shepherd-service
        (provision '(firewall-configurator))
        (one-shot? #t)
        (start #~(lambda ()
          (system (string-append
            "export PATH=\"/run/current-system/profile/sbin\" && "
            "iptables -P FORWARD DROP && "
            "iptables -P INPUT DROP && "
            "iptables -A INPUT -p udp -s localhost -j ACCEPT && "
            "iptables -A INPUT -p tcp -s localhost -j ACCEPT && "
            "iptables -A INPUT -p icmp -s localhost -j ACCEPT && "
            "iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT"))
          #t)))
      (shepherd-service
        (provision '(data-unlocker))
        (requirement '(file-systems))
        (one-shot? #t)
        (start #~(lambda ()
          (system*
            "/run/current-system/profile/sbin/cryptsetup"
            "luksOpen"
            "-d"
            "/etc/datakey"
            "/dev/disk/by-uuid/5bebe2d2-9fce-4848-be18-0929cba8a61d"
            "data")
          #t)))
      (shepherd-service
        (provision '(data-mounter))
        (requirement '(data-unlocker))
        (one-shot? #t)
        (start #~(lambda ()
          (invoke
            "/run/setuid-programs/mount"
            "/dev/mapper/data"
            "/mnt/data")
          #t)))
      (shepherd-service
        (provision '(brightness-setter))
        (requirement '(elogind))
        (one-shot? #t)
        (start #~(lambda ()
          (invoke
            "/run/current-system/profile/bin/brightnessctl"
            "set"
            "20%")
          #t)))))
    (remove
      (lambda (x)
        (eq? (service-kind x) gdm-service-type))
      %desktop-services)))
  (bootloader (bootloader-configuration
    (bootloader grub-efi-bootloader)
    (targets '("/boot/efi"))
    (keyboard-layout keyboard-layout)))
  (mapped-devices (list
    (mapped-device
      (source (uuid "f8aa03c8-87e4-49c5-98ad-e3faf3e2309c"))
      (target "cryptroot")
      (type luks-device-mapping))))
  (file-systems (cons*
    (file-system
      (mount-point "/")
      (device "/dev/mapper/cryptroot")
      (type "ext4")
      (dependencies mapped-devices))
    (file-system
      (mount-point "/boot/efi")
      (device (uuid "3D91-565E" 'fat))
      (type "vfat"))
    %base-file-systems))
  (swap-devices (list (swap-space (target "/swapfile")))))

