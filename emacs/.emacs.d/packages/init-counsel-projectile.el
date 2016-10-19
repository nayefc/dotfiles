(use-package counsel-projectile
  :ensure t
  :bind ("C-x f" . counsel-projectile-find-file)
  :init
  (counsel-projectile-on))

(provide 'init-counsel-projectile)
