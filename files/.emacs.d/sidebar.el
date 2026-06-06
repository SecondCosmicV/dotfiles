(defun sidebar ()
  (interactive)
  (when (eq major-mode 'dired-mode)
    (delete-other-windows)
    (set-window-buffer
      (split-window-right 50)
      "*scratch*")
    (dired-hide-details-mode 1)))

