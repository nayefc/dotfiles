(use-package neotree
  :ensure t
  :defer t
  :init
  ;; (setq projectile-switch-project-action 'neotree-projectile-action)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-smart-open t))

(provide 'init-neotree)
