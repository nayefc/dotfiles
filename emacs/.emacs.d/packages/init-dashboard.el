(use-package dashboard
  :config
  (require 'projectile)
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((projects . 10)
			  (recents  . 10))))

(provide 'init-dashboard)
