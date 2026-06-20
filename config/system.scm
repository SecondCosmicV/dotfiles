(use-modules
  (gnu)
  (gnu packages cryptsetup)
  (gnu packages linux)
  (gnu packages wm)
  (gnu services desktop)
  (gnu services pm)
  (gnu services shepherd)
  (gnu services virtualization)
  (gnu services xorg)
  (nongnu packages linux)
  (nongnu system linux-initrd)
  (suika-chan services docker-binary))
(include "./hosts.scm")
(define base-operating-system (operating-system
  (kernel linux)
  (kernel-arguments (cons*
    "ipv6.disable=1"
    "modprobe.blacklist=pcspkr"
    %default-kernel-arguments))
  (initrd microcode-initrd)
  (locale "de_DE.utf8")
  (timezone "Europe/Berlin")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "darkstar")
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
  (packages (cons*
    brightnessctl
    cryptsetup
    iptables
    %base-packages))
  (services (cons*
    (service startx-command-service-type)
    (service screen-locker-service-type (screen-locker-configuration
      (name "i3lock")
      (program (file-append i3lock "/bin/i3lock"))))
    (service tlp-service-type (tlp-configuration
      (stop-charge-thresh-bat0 80)
      (start-charge-thresh-bat0 75)
      (ahci-runtime-pm-on-ac? #t)
      (ahci-runtime-pm-on-bat? #t)))
    (service libvirt-service-type)
    (service virtlog-service-type)
    (service docker-binary-service-type)
    (udev-rules-service 'display-thing (udev-rule
      "90-display-thing.rules"
      (string-append
        "ACTION==\"change\","
        "SUBSYSTEM==\"drm\","
        "ENV{HOTPLUG}==\"1\","
        "RUN+=\"/bin/sh -c 'kill -USR1 $$(/run/current-system/profile/bin/cat /tmp/monman.pid)'\"\n")))
    (simple-service 'my-hosts-service hosts-service-type my-hosts)
    (simple-service 'libvirt-network-conf activation-service-type
      #~(begin
          (mkdir-p "/etc/libvirt")
          (call-with-output-file
            "/etc/libvirt/network.conf"
            (lambda (port)
              (display
                "firewall_backend = \"iptables\"\n"
                port)))))
    (simple-service 'my-base-service shepherd-root-service-type (list
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
        (provision '(brightness-setter))
        (requirement '(elogind))
        (one-shot? #t)
        (start #~(lambda ()
          (invoke
            "/run/current-system/profile/bin/brightnessctl"
            "set"
            "20%")
          #t)))))
    (modify-services %desktop-services
      (delete gdm-service-type))))
  (bootloader (bootloader-configuration
    (bootloader grub-efi-bootloader)
    (targets '("/boot/efi"))
    (keyboard-layout keyboard-layout)))
  (file-systems '())
  (swap-devices (list (swap-space (target "/swapfile"))))))

