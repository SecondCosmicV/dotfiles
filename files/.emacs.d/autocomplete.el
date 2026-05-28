(use-package cape
  :ensure t
  :init (add-to-list 'completion-at-point-functions #'cape-keyword))
(use-package eglot
  :hook (
    (c-mode . eglot-ensure)
    (c++-mode . eglot-ensure)
    (python-mode . eglot-ensure))
  :custom (eglot-autoshutdown t))
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0)
  (corfu-cycle t)
  (corfu-quit-no-match t)
  :hook ((prog-mode . corfu-mode)))
(setq-default eglot-workspace-configuration '(:pylsp (:plugins (:pycodestyle (:enabled nil)))))
(add-hook 'eglot-managed-mode-hook (lambda ()
  (setq-local completion-at-point-functions (list (cape-capf-super
    #'eglot-completion-at-point
    #'cape-keyword)))))

