(use-package git-gutter+
  :ensure t
  :diminish (git-gutter+-mode "gg")
  :bind (("C-x n" . git-gutter+-next-hunk)
	 ("C-x p" . git-gutter+-previous-hunk)
	 ("C-x t" . git-gutter+-stage-hunks)
	 ("C-x a c" . git-gutter+-stage-and-commit))
  :init
  (add-hook 'python-mode-hook 'git-gutter+-mode))

(provide 'init-git-gutter)
