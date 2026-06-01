(use-package cape
  :ensure t
  :init (add-to-list 'completion-at-point-functions #'cape-keyword))
(use-package eglot
  :custom (eglot-autoshutdown t)
  :hook (
    (c-mode . eglot-ensure)
    (c++-mode . eglot-ensure)
    (python-mode . eglot-ensure))
  :config (add-to-list 'eglot-server-programs '((c-mode c++-mode) . ("clangd" "--header-insertion=never"))))
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0)
  (corfu-cycle t)
  (corfu-quit-no-match t)
  :bind (:map corfu-map ("RET" . nil))
  :hook ((prog-mode . corfu-mode)))
(setq-default eglot-workspace-configuration '(:pylsp (:plugins (:pycodestyle (:enabled nil)))))
(add-hook 'eglot-managed-mode-hook (lambda ()
  (when
    (or
      (derived-mode-p 'c-mode)
      (derived-mode-p 'c++-mode))
    (setq-local completion-at-point-functions (list (cape-capf-super
      #'eglot-completion-at-point
      #'cape-keyword))))))

