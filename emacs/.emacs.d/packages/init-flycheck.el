(use-package flycheck
  :ensure t
  :init
  (setq flycheck-highlighting-mode 'lines)
  (setq flycheck-check-syntax-automatically '(mode-enabled new-line idle-change))
  (setq flycheck-idle-change-delay 1)
  (set-face-attribute 'flycheck-error nil :foreground "yellow" :background "red")
  (set-face-attribute 'flycheck-warning nil :foreground "red" :background "yellow")
  (set-face-attribute 'flycheck-info nil :foreground "red" :background "yellow"))

(if is-a-mac
    (eval-after-load 'flycheck
      '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)))

(add-hook 'after-init-hook #'global-flycheck-mode)

(provide 'init-flycheck)
