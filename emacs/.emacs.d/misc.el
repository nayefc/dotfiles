;;; misc.el --- Misc configuration
;;; Commentary:

;;; Code:

(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)
(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; Remove Emacs startup screen
(setq inhibit-startup-screen +1)

;; Remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Disable source control hooks (i.e: vc-git)
(setq vc-handled-backends nil)

;; Activate pyenv-mode
(pyenv-mode)

;; Remove top menu bar
(menu-bar-mode -1)

;; Turn on icomplete-mode, replacing iswitch for v24.4
(icomplete-mode 1)

;; Overwrite text when writing over a highlighted region
(delete-selection-mode t)

;; Show which function you're in
(which-function-mode)
(setq which-func-unknown "n/a")

;; Add space on the margin for line numbering
(setq linum-format "%d ")

;; Buffer name for for two files in different directories shows full path instead of <2>
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Display line numbers
(global-linum-mode t)

;; Display line numbers at the bottom
(setq line-number-mode t)

;; Highlight parenthesis matching pair
(show-paren-mode 1)

;; Put all emacs backup files in one directory
(setq backup-directory-alist `(("." . "~/.saves")))

;; Add dired-x mode to dired
(add-hook 'dired-load-hook
	  (lambda ()
	    (load "dired-x")))

(put 'dired-find-alternate-file 'disabled nil)

;; Change default switch-to-buffer binding for consistency with helm-buffers-list
(bind-key "C-x C-b" 'switch-to-buffer)

;; Print out projectile project name
;; See http://www.lunaryorn.com/2014/07/26/make-your-emacs-mode-line-more-useful.html
(defvar my-projectile-mode-line
  '(:propertize
    (:eval (when (ignore-errors (projectile-project-root))
	     (concat " " (projectile-project-name))))
    face font-lock-constant-face)
  "Mode line format for Projectile.")
(put 'lunaryorn-projectile-mode-line 'risky-local-variable t)

;; Custom mode-line-format
(setq-default mode-line-format
	      '("%e" mode-line-front-space
		;; Standard info about the current buffer
		mode-line-mule-info
		;;mode-line-client
		mode-line-modified
		mode-line-buffer-identification " " mode-line-position
		;; Some specific information about the current buffer:
		my-projectile-mode-line ; Project information
		(flycheck-mode flycheck-mode-line) ; Flycheck status
		(multiple-cursors-mode mc/mode-line) ; Number of cursors
		" "
		mode-line-misc-info
		;; And the modes, which I don't really care for anyway
		;; " " mode-line-modes mode-line-end-spaces))
		))

(provide 'misc)
;;; misc.el ends here
