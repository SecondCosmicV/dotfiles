(defun sidebar ()
  (interactive)
  (set-window-buffer
    (split-window-right 50)
    "*scratch*")
  (dired-hide-details-mode 1))

