(use-package git-gutter+
  :ensure t
  :commands git-gutter+-mode
  :config
  (bind-keys :map dired-mode-map
	     ("C-x n" . git-gutter+-next-hunk)
	     ("C-x p" . git-gutter+-previous-hunk)
	     ("C-x t" . git-gutter+-stage-hunks)
	     ("C-x a c" . git-gutter+-stage-and-commit))
  :diminish (git-gutter+-mode "gg"))

(provide 'init-git-gutter)
