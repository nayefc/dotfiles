(use-package helm
  :ensure t
  :config
  (helm-autoresize-mode 1)
  ;; open helm buffer inside current window, not occupy whole other window
  (setq helm-split-window-in-side-p t
	;; move to end or beginning of source when reaching top or bottom of source.
	helm-move-to-line-cycle-in-source t
	;; search for library in `require' and `declare-function' sexp.
	helm-ff-search-library-in-sexp t
	;; scroll 8 lines other window using M-<next>/M-<prior>
	helm-scroll-amount 8
	helm-ff-file-name-history-use-recentf t)

  (setq helm-buffers-fuzzy-matching t))

(use-package helm-git-grep
  :ensure t
  :bind (("C-c g" . helm-git-grep)
	 ("C-c h" . helm-git-grep-at-point))
  :config
  (eval-after-load 'helm
    '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm)))

(provide 'init-helm)
