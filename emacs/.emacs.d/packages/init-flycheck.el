(use-package flycheck
  :ensure t
  :init
  (setq flycheck-highlighting-mode 'symbols)
  (setq flycheck-check-syntax-automatically '(mode-enabled new-line idle-change))
  (setq flycheck-idle-change-delay 1)
  :config
  (set-face-attribute 'flycheck-error nil :foreground "yellow" :background "red")
  (set-face-attribute 'flycheck-warning nil :foreground "red" :background "yellow")
  (set-face-attribute 'flycheck-info nil :foreground "red" :background "yellow"))

(add-hook 'after-init-hook #'global-flycheck-mode)

(provide 'init-flycheck)
