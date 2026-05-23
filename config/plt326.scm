(include "./system.scm")
(operating-system
  (inherit base-operating-system)
  (firmware (cons*
    amdgpu-firmware
    realtek-firmware
    %base-firmware))
  (host-name "plt326")
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
    %base-file-systems)))

