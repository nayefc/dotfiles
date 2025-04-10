(use-package dashboard
  :ensure t
  :config
  (require 'projectile)
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((projects . 10)
                          (recents  . 10)))
  (setq dashboard-startup-banner 'logo))

(provide 'init-dashboard)
