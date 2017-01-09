(use-package golden-ratio
  :ensure t
  :diminish golden-ratio-mode
  :init
  (golden-ratio-mode 1)
  (setq golden-ratio-adjust-factor .8
	golden-ratio-wide-adjust-factor .8))

(provide 'init-golden-ratio)
