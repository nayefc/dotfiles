(use-package highlight-symbol
  :ensure t
  :defer t
  :bind (("C-c w" . highlight-symbol)
	 ("C-c a" . highlight-symbol-next)
	 ("C-c s" . highlight-symbol-prev)
	 ("C-c q" . highlight-symbol-remove-all))
  :init
  (setq highlight-symbol-colors
	'("DeepPink" "cyan" "MediumPurple1" "SpringGreen1"
	  "DarkOrange" "HotPink1" "RoyalBlue1" "OliveDrab")))

(provide 'init-highlight-symbol)
