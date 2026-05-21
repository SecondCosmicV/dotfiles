(include "./system.scm")
(operating-system
  (inherit base-operating-system)
  (host-name "plt326")
  (mapped-devices (list
    (mapped-device
      (source (uuid ""))
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
      (device (uuid "" 'fat))
      (type "vfat"))
    %base-file-systems)))

