(use-package avy
  :ensure t
  :bind (("C-\"" . avy-goto-char)
         ("C-'" . avy-goto-word-1)
         ("M-1" . avy-goto-line))
  :init
  (setq avy-background t)
  (setq avy-keys (number-sequence ?a ?z)))

(provide 'init-avy)
