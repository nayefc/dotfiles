(use-package buffer-move
  :ensure t
  :bind (("C-S-<left>" . buf-move-left)
	 ("C-S-<right>" . buf-move-right)))

(provide 'init-buffer-move)
