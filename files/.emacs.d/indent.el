(defun my-indent--apply-on-region-lines (fn)
  (let (
    (beg (line-number-at-pos (region-beginning)))
    (end (line-number-at-pos (region-end))))
    (save-excursion
      (goto-line beg)
      (while (<= (line-number-at-pos) end)
        (back-to-indentation)
        (funcall fn)
        (forward-line 1))))
  (setq deactivate-mark nil))
(defun my-indent--detect-indent (fallback)
  (save-excursion
    (beginning-of-buffer)
    (if (re-search-forward "^\\( +\\|\t+\\)" nil t)
      (let ((ws (match-string 1)))
        (if (string-match-p "^\t" ws)
          (progn
            (setq-local indent-tabs-mode t)
            (setq-local tab-width fallback))
          (setq-local indent-tabs-mode nil)
          (setq-local tab-width (length ws))))
      (setq-local indent-tabs-mode nil)
      (setq-local tab-width fallback))))
(defun my-indent--get-num-spaces ()
  (-
    (point)
    (save-excursion
      (skip-chars-backward " " (line-beginning-position))
      (point))))
(defun my-indent--indent ()
  (if indent-tabs-mode
    (insert "\t")
    (insert (make-string (- tab-width (mod (my-indent--get-num-spaces) tab-width)) ?\s))))
(defun my-indent--dedent ()
  (let ((to-delete 1))
    (when (not indent-tabs-mode)
      (let ((num-spaces (my-indent--get-num-spaces)))
        (when (not (zerop num-spaces))
          (setq to-delete (mod num-spaces tab-width))
          (when (zerop to-delete)
            (setq to-delete tab-width)))))
    (delete-char (- to-delete))))
(defun my-indent--tab ()
  (interactive)
  (if (use-region-p)
    (my-indent--apply-on-region-lines
      (lambda ()
        (insert
          (if indent-tabs-mode
            "\t"
            (make-string tab-width ?\s)))))
    (my-indent--indent)))
(defun my-indent--shift-tab ()
  (interactive)
  (when (use-region-p)
    (my-indent--apply-on-region-lines
      (lambda ()
        (delete-char
          (-
            (if indent-tabs-mode
              1
              (min tab-width (my-indent--get-num-spaces)))))))))
(defun my-indent--backspace ()
  (interactive)
  (if (use-region-p)
    (delete-region (region-beginning) (region-end))
    (my-indent--dedent)))
(defun my-indent--newline ()
  (interactive)
  (let (
    (indent
      (save-excursion
        (back-to-indentation)
        (buffer-substring (line-beginning-position) (point))))
    (rest (delete-and-extract-region (point) (line-end-position))))
    (insert "\n" indent rest))
  (back-to-indentation))
(define-minor-mode my-indent--my-indent-mode
  "Minor mode for usable indentation logic."
  :lighter " MI"
  :keymap (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") 'my-indent--newline)
    (define-key map (kbd "TAB") 'my-indent--tab)
    (define-key map (kbd "<backtab>") 'my-indent--shift-tab)
    (define-key map (kbd "<backspace>") 'my-indent--backspace)
    map))
(add-hook 'before-save-hook
  (lambda ()
    (let ((pref (buffer-substring (pos-bol) (point))))
      (delete-trailing-whitespace)
      (when (= (point) (pos-bol))
        (insert pref)))
    (save-excursion
      (goto-char (point-max))
      (insert "\n"))))
(add-hook 'c++-mode-hook
  (lambda ()
    (setq-local c-electric-flag nil)))
(dolist
  (hook '(
    c++-mode-hook
    c-mode-hook
    conf-unix-mode-hook
    css-mode-hook
    dockerfile-mode-hook
    emacs-lisp-mode-hook
    html-mode-hook
    js-mode-hook
    json-mode-hook
    latex-mode-hook
    lisp-interaction-mode-hook
    mhtml-mode-hook
    python-mode-hook
    scheme-mode-hook
    scheme-mode-hook
    sh-mode-hook
    yaml-mode-hook))
  (add-hook hook #'my-indent--my-indent-mode))
(dolist
  (hook '(
    c++-mode-hook
    c-mode-hook
    conf-unix-mode-hook
    css-mode-hook
    dockerfile-mode-hook
    html-mode-hook
    latex-mode-hook
    mhtml-mode-hook
    python-mode-hook
    sh-mode-hook))
  (add-hook hook (lambda () (my-indent--detect-indent 4))))
(dolist
  (hook '(
    emacs-lisp-mode-hook
    js-mode-hook
    json-mode-hook
    lisp-interaction-mode-hook
    scheme-mode-hook
    yaml-mode-hook))
  (add-hook hook (lambda () (my-indent--detect-indent 2))))

