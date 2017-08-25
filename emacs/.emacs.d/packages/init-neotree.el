(use-package neotree
  :ensure t
  :defer t
  :init
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-smart-open t)
  (setq neo-window-fixed-size nil))

(provide 'init-neotree)
