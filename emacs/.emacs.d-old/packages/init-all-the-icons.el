(use-package all-the-icons
  :ensure t)

(use-package all-the-icons-dired
  :ensure t
  :init
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

(use-package all-the-icons-ivy
  :ensure t
  :config
  (all-the-icons-ivy-setup))

(provide 'init-all-the-icons)
