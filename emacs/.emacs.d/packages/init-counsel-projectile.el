(use-package counsel-projectile
  :ensure t
  :bind ("C-x f" . counsel-projectile-find-file)
  :init
  (counsel-projectile-mode))

(provide 'init-counsel-projectile)
