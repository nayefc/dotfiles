(use-package
  :ensure t
  all-the-icons)

(use-package all-the-icons-dired
  :ensure t
  :init
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

(provide 'init-all-the-icons)
