(use-package flycheck
  :ensure t
  :commands global-flycheck-mode
  :init
  (setq flycheck-highlighting-mode 'lines)
  (setq flycheck-check-syntax-automatically '(mode-enabled new-line idle-change))
  (setq flycheck-idle-change-delay 1)
  :config
  (set-face-attribute 'flycheck-error nil :foreground "yellow" :background "red")
  (set-face-attribute 'flycheck-warning nil :foreground "red" :background "yellow")
  (set-face-attribute 'flycheck-info nil :foreground "red" :background "yellow"))
  ;;;;(global-flycheck-mode)

(provide 'init-flycheck)
