;;; package -- Summary:
;;; Commentary:
;;; Code:

(use-package eyebrowse
  :diminish
  :defer 2
  :config
  (setq eyebrowse-new-workspace t)
  (setq eyebrowse-wrap-around t)
  (bind-keys :map eyebrowse-mode-map
	     ("C-c C-w k" . eyebrowse-close-window-config)
	     ("C-c C-w n" . eyebrowse-next-window-config)
	     ("C-c C-w p" . eyebrowse-prev-window-config)))

(provide 'init-eyebrowse)
;;; init-eyebrowse.el ends here
