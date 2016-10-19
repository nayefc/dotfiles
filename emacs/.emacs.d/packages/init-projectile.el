;(advice-add 'create-file-buffer :around #'show-file-path-in-projectile-project)
(defun show-file-path-in-projectile-project ()
  "Show the full path of the file relative to the projectile project."
  (interactive)
  ;; TODO:
  ;; Use advice from:
  ;; https://github.com/emacs-mirror/emacs/blob/0537943561a37b54467bec19d1b8afbeba8e1e58/lisp/uniquify.el
  ;; Move outside of init; figure out why its not working.
  (defvar project-dir)
  (if (car (projectile-get-project-directories))
      (setq project-dir (car (projectile-get-project-directories))))

  (if (buffer-file-name)
      (if project-dir
	  (if (f-descendant-of? buffer-file-name project-dir)
	      (rename-buffer
	       (car (cdr
		     (split-string
		      (buffer-file-name)
		      (car (projectile-get-project-directories))))))))))
(bind-key "M-[" 'show-file-path-in-projectile-project)

;; Print out projectile project name
;; See http://www.lunaryorn.com/2014/07/26/make-your-emacs-mode-line-more-useful.html
(defvar my-projectile-mode-line
  '(:propertize
    (:eval (when (ignore-errors (projectile-project-root))
	     (concat " " (projectile-project-name))))
    face font-lock-constant-face)
  "Mode line format for Projectile.")
(put 'lunaryorn-projectile-mode-line 'risky-local-variable t)

(use-package projectile
  :ensure t
  :defer t
  :config
  (ivy-mode 1)
  (projectile-global-mode)
  (setq projectile-completion-system 'ivy)
  ;; This has to come after activating on the mode.
  (setq projectile-switch-project-action 'projectile-dired))

(provide 'init-projectile)
