(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)
(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; Remove Emacs startup screen
(setq inhibit-startup-screen +1)

;; Disable ring bell alerts
(setq ring-bell-function 'ignore)

;; Remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Disable source control hooks (i.e: vc-git)
(setq vc-handled-backends nil)

;; Remove top menu bar
(menu-bar-mode -1)

;; Overwrite text when writing over a highlighted region
(delete-selection-mode t)

;; Show which function you're in
(which-function-mode)
(setq which-func-unknown "n/a")

;; Display line numbers at the bottom
(setq line-number-mode t)

;; Highlight parenthesis matching pair
(show-paren-mode 1)

;; Put all emacs backup files in one directory
(setq backup-directory-alist `(("." . "~/.saves")))

;; Turn off auto revert messages
(setq auto-revert-verbose nil)

(unbind-key "C-x m" global-map)

;; Custom mode-line-format
(setq-default mode-line-format
	      '("%e" mode-line-front-space
		;; Standard info about the current buffer
		mode-line-mule-info
		;;mode-line-client
		mode-line-modified
		" "
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

(provide 'init-default-settings)
