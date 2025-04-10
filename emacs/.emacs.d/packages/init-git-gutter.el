(use-package git-gutter+
  :ensure t
  :defer t
  :diminish (git-gutter+-mode "gg"))

(add-hook 'python-mode-hook 'git-gutter+-mode)
(add-hook 'c-mode-common-hook 'git-gutter+-mode)

(provide 'init-git-gutter)
