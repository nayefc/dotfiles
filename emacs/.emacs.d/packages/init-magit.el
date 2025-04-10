(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :defines magit-last-seen-setup-instructions
  :init
  (setq magit-last-seen-setup-instructions "1.4.0")
  :config
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))

  (defun magit-quit-session ()
    "Restores the previous window configuration and kills the magit buffer"
    (interactive)
    (kill-buffer)
    (jump-to-register :magit-fullscreen))

  (setq magit-completing-read-function 'ivy-completing-read)

  (bind-key "q" 'magit-quit-session magit-status-mode-map))

(provide 'init-magit)
