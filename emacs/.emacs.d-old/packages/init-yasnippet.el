(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :commands (yas-global-mode yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :ensure t)

(add-hook 'python-mode-hook #'yas-minor-mode)
(add-hook 'c-mode-hook #'yas-minor-mode)
(add-hook 'c++-mode-hook #'yas-minor-mode)

(provide 'init-yasnippet)
