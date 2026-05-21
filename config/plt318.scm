(include "./system.scm")
(operating-system
  (inherit base-operating-system)
  (firmware (cons
    iwlwifi-firmware
    %base-firmware))
  (host-name "plt318")
  (services (cons*
    (simple-service 'plt318-service shepherd-root-service-type (list
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
          #t)))))
    (operating-system-user-services base-operating-system)))
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
    %base-file-systems)))

