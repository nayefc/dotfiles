; Set GUI Emacs theme
(use-package solarized-theme
  :ensure t
  :if (display-graphic-p)
  :init
  (progn
    ;; Set default window size
    (add-to-list 'default-frame-alist '(height . 30))
    (add-to-list 'default-frame-alist '(width . 90))

    (setq solarized-use-variable-pitch nil)
    (setq solarized-scale-headlines nil)

    ;; Disable toolbar
    (tool-bar-mode -1)

    ;; Disable scroll bar
    (scroll-bar-mode -1)

    ;; Load theme
    (load-theme 'solarized-dark t)

    ;; make the fringe stand out from the background
    (setq solarized-distinct-fringe-background t)

    ;; make the modeline high contrast
    (setq solarized-high-contrast-mode-line t)

    ;; Use less bolding
    (setq solarized-use-less-bold t)

    ;; Use more italics
    (setq solarized-use-more-italic t)

    ;; Use less colors for indicators such as git:gutter, flycheck and similar.
    (setq solarized-emphasize-indicators nil)

    (setq x-underline-at-descent-line t)

    ;; Highlight current line
    (global-hl-line-mode +1)))

(defun finder ()
  "Opens file directory in Finder."
  (interactive)
  (let ((file (buffer-file-name)))
    (if file
        (shell-command
         (format "%s %s" (executable-find "open") (file-name-directory file)))
      (error "Buffer is not attached to any file"))))

(provide 'init-gui)
