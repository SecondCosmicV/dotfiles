(include "./system.scm")
(operating-system
  (inherit base-operating-system)
  (firmware (cons
    realtek-firmware
    %base-firmware))
  (host-name "plt326")
  (mapped-devices (list
    (mapped-device
      (source (uuid "b7cce036-b6d9-49e8-bd0a-024557d0fade"))
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
      (device (uuid "F0CE-0660" 'fat))
      (type "vfat"))
    %base-file-systems)))

