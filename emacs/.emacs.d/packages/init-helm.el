(use-package helm
  :ensure t
  :commands helm-mode
  :defines helm-ff-search-library-in-sexp helm-ff-file-name-history-use-recentf helm-buffers-fuzzy-matching
  :bind (("M-x" . helm-M-x)
	 ("C-x b" . helm-buffers-list)
	 ("C-x f" . helm-projectile-find-file))
  :init
  ;; This seems to fix an issue with Amman ISP when they do some DNS routing that crash Tramp on startup.
  ;; It also seems to speed up Tramp in general when editing on other machines via Tramp.
  (setq tramp-ssh-controlmaster-options
  	(concat
  	 "-o ControlPath=/tmp/ssh-ControlPath-%%r@%%h:%%p "
         "-o ControlMaster=auto -o ControlPersist=yes"))
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

  ;; rebind tab to run persistent action
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  ;; make TAB works in terminal
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
  ;; list actions using C-z
  (define-key helm-map (kbd "C-z")  'helm-select-action)

  (setq helm-buffers-fuzzy-matching t))

(use-package helm-git-grep
  :ensure t
  :bind (("C-c g" . helm-git-grep)
	 ("C-c h" . helm-git-grep-at-point))
  :config
  (eval-after-load 'helm
    '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm)))

(provide 'init-helm)
