(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; (use-package magit
;;   :ensure t
;;   :bind ("C-x g" . magit-status)
;;   :defines magit-last-seen-setup-instructions
;;   :init
;;   (setq magit-last-seen-setup-instructions "1.4.0")
;;   :config
;;   (defadvice magit-status (around magit-fullscreen activate)
;;     (window-configuration-to-register :magit-fullscreen)
;;     ad-do-it
;;     (delete-other-windows))
;;   (defun magit-quit-session ()
;;     "Restores the previous window configuration and kills the magit buffer"
;;     (interactive)
;;     (kill-buffer)
;;     (jump-to-register :magit-fullscreen))
;;   (bind-key "q" 'magit-quit-session magit-status-mode-map))

;; (use-package magit
;;   :ensure t
;;   ;; :commands magit-get-top-dir
;;   :bind (("C-x g" . magit-status))
;; 	 ;; ("C-c C-g l" . magit-file-log)
;; 	 ;; ("C-c f" . magit-grep))
;;   :init
;;   (progn
;;     ;; magit extensions
;;     (use-package magit-blame
;;       :bind ("C-c C-g b" . magit-blame-mode))

;;     ;; we no longer need vc-git
;;     (delete 'Git vc-handled-backends)
;;     ;; make magit status go full-screen but remember previous window
;;     ;; settings
;;     ;; from: http://whattheemacsd.com/setup-magit.el-01.html
;;     (defadvice magit-status (around magit-fullscreen activate)
;;       (window-configuration-to-register :magit-fullscreen)
;;       ad-do-it
;;       (delete-other-windows))

;;     ;; Close popup when commiting - this stops the commit window
;;     ;; hanging around
;;     ;; From: http://git.io/rPBE0Q
;;     (defadvice git-commit-commit (after delete-window activate)
;;       (delete-window))

;;     (defadvice git-commit-abort (after delete-window activate)
;;       (delete-window))

;;     ;; these two force a new line to be inserted into a commit window,
;;     ;; which stops the invalid style showing up.
;;     ;; From: http://git.io/rPBE0Q
;;     (defun magit-commit-mode-init ()
;;       (when (looking-at "\n")
;; 	(open-line 1)))

;;     (add-hook 'git-commit-mode-hook 'magit-commit-mode-init))
;;   :config
;;   (progn
;;     ;; restore previously hidden windows
;;     (defadvice magit-quit-window (around magit-restore-screen activate)
;;       (let ((current-mode major-mode))
;; 	ad-do-it
;; 	;; we only want to jump to register when the last seen buffer
;; 	;; was a magit-status buffer.
;; 	(when (eq 'magit-status-mode current-mode)
;; 	  (jump-to-register :magit-fullscreen))))

;;     (defun magit-maybe-commit (&optional show-options)
;;       "Runs magit-commit unless prefix is passed"
;;       (interactive "P")
;;       (if show-options
;; 	  (magit-key-mode-popup-committing)
;; 	(magit-commit)))

;;     (define-key magit-mode-map "c" 'magit-maybe-commit)

;;     ;; major mode for editing `git rebase -i` files
;;     (use-package rebase-mode)

;;     ;; magit settings
;;     (setq
;;      ;; use ido to look for branches
;;      magit-completing-read-function 'magit-ido-completing-read
;;      ;; don't put "origin-" in front of new branch names by default
;;      magit-default-tracking-name-function 'magit-default-tracking-name-branch-only
;;      ;; open magit status in same window as current buffer
;;      magit-status-buffer-switch-function 'switch-to-buffer
;;      ;; highlight word/letter changes in hunk diffs
;;      magit-diff-refine-hunk t
;;      ;; ask me if I want to include a revision when rewriting
;;      magit-rewrite-inclusive 'ask
;;      ;; ask me to save buffers
;;      magit-save-some-buffers t
;;      ;; pop the process buffer if we're taking a while to complete
;;      magit-process-popup-time 10
;;      ;; ask me if I want a tracking upstream
;;      magit-set-upstream-on-push 'askifnotset
;;      )))

;; (use-package magit
;;   :ensure t
;;   ;;:commands magit-get-top-dir
;;   ;;:bind ("C-x g" . magit-status)
;;   :config
;;   (progn
;;   (defadvice magit-status (around magit-fullscreen activate)
;;     (window-configuration-to-register :magit-fullscreen)
;;     ad-do-it
;;     (delete-other-windows))
;;   (defun magit-quit-session ()
;;     "Restores the previous window configuration and kills the magit buffer"
;;     (interactive)
;;     (kill-buffer)
;;     (jump-to-register :magit-fullscreen))))

;; ;; (use-package magit
;; ;;   :ensure t
;; ;;    ;;:bind ("C-x g" .magit-status)
;; ;;   ;; :commands magit-status
;; ;;   ;; :defines magit-last-seen-setup-instructions
;; ;;   :init
;; ;;   (setq magit-last-seen-setup-instructions "1.4.0")
;; ;; )
;;   ;; :config
;;   ;; (defadvice magit-status (around magit-fullscreen activate)
;;   ;;   (window-configuration-to-register :magit-fullscreen)
;;   ;;   ad-do-it
;;   ;;   (delete-other-windows))
;;   ;; (defun magit-quit-session ()
;;   ;;   "Restores the previous window configuration and kills the magit buffer"
;;   ;;   (interactive)
;;   ;;   (kill-buffer)
;;   ;;   (jump-to-register :magit-fullscreen))
;;   ;; (bind-key "q" 'magit-quit-session magit-status-mode-map))

(provide 'init-magit)
