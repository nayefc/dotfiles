(use-package git-gutter+
  :ensure t
  :diminish (git-gutter+-mode "gg")
  :init
  (add-hook 'python-mode-hook 'git-gutter+-mode))

(provide 'init-git-gutter)
