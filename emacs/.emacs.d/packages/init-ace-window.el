(use-package ace-window
  :ensure t
  :bind ("M-p" . ace-window)
  :init
  ;;(setq aw-background nil)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(provide 'init-ace-window)
