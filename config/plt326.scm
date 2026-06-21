(use-modules
  (suika-chan packages provide-virtual-touchpad))
(include "./system.scm")
(define plt326-operating-system (operating-system
  (inherit base-operating-system)
  (kernel-arguments (cons
    "amdgpu.abmlevel=0"
    (operating-system-user-kernel-arguments base-operating-system)))
  (firmware (cons*
    amdgpu-firmware
    realtek-firmware
    %base-firmware))
  (host-name "plt326")
  (packages (cons
    provide-virtual-touchpad
    (operating-system-packages base-operating-system)))
  (services (cons*
    (udev-rules-service 'touchpad-thing (udev-rule
      "90-touchpad-thing.rules"
      (string-append
        "SUBSYSTEM==\"input\","
        "ENV{ID_INPUT_TOUCHPAD}==\"1\","
        "SYMLINK+=\"input/touchpad\"")))
    (simple-service 'libvirt-hooks-service activation-service-type
      #~(begin
          (mkdir-p "/etc/libvirt/hooks")
          (call-with-output-file
            "/etc/libvirt/hooks/qemu"
            (lambda (port)
              (display
                "#!/usr/bin/env bash
[ \"$1\" == \"win10\" ] || exit 0
GUIX_PROFILE=/run/current-system
source $GUIX_PROFILE/etc/profile
case \"$2\" in
    prepare)
        nohup provide-virtual-touchpad > /dev/null 2>&1 &
        while [ ! -e /dev/input/virtual-touchpad ]; do
            sleep 1
        done
        ;;
    release)
      halt
      ;;
esac
"
                port)))
          (chmod "/etc/libvirt/hooks/qemu" #o755)))
    (simple-service 'my-plt326-service shepherd-root-service-type (list
      (shepherd-service
        (provision '(vm-autostarter))
        (requirement '(
          libvirtd
          udev
          virtlogd))
        (one-shot? #t)
        (start #~(lambda ()
          (system (string-append
            "PATH=\"/run/current-system/profile/bin\" && "
            "grep -w \"modprobe.blacklist=amdgpu\" /proc/cmdline && "
            "while ! virsh list; do sleep 1; done && "
            "virsh start win10"))
          #t)))))
    (operating-system-user-services base-operating-system)))
  (mapped-devices (list
    (mapped-device
      (source (uuid "31682a4c-ab7a-4db0-8be6-a5a30345b467"))
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
      (device (uuid "F135-61D8" 'fat))
      (type "vfat"))
    %base-file-systems))))
(operating-system
  (inherit plt326-operating-system)
  (bootloader (bootloader-configuration
    (inherit (operating-system-bootloader plt326-operating-system))
    (menu-entries (list
      (menu-entry
        (label "Win10 (VM)")
        (linux (operating-system-kernel-file plt326-operating-system))
        (initrd (operating-system-initrd-file plt326-operating-system))
        (linux-arguments (cons
          "modprobe.blacklist=amdgpu"
          (operating-system-kernel-arguments
            plt326-operating-system
            (file-system-device (operating-system-root-file-system plt326-operating-system)))))))))))

