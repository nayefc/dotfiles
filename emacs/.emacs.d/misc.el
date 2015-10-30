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

(defun copy-function-name ()
  "Put name of function at point to kill-ring."
  (interactive)
  (kill-new (which-function)))

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

(defun hs-enable-and-toggle ()
  "Enable hs and toggle block."
  (interactive)
  (hs-minor-mode 1)
  (hs-toggle-hiding))
(bind-key "C-x ," 'hs-enable-and-toggle)
;; (defun hs-enable-and-hideshow-all (&optional arg)
;;   "Hide all blocks. If prefix argument is given, show all blocks."
;;   (interactive "P")
;;   (hs-minor-mode 1)
;;   (if arg
;;       (hs-show-all)
;;     (hs-hide-all)))
;; (global-set-key (kbd "C-c C-j") 'hs-enable-and-hideshow-all)

;; Scale font size and adjust fci column ruler.
(define-globalized-minor-mode global-text-scale-mode text-scale-mode
  (lambda ()
    (text-scale-mode 1)))

(defun global-text-scale-adjust (inc)
  (interactive)
  (text-scale-set 1)
  (kill-local-variable 'text-scale-mode-amount)
  (setq-default text-scale-mode-amount (+ text-scale-mode-amount inc))
  (global-text-scale-mode 1))

(defun reset-font-size ()
  "Reset font size on all buffers to default."
  (interactive)
  (fci-mode 0)
  (global-text-scale-adjust (- text-scale-mode-amount))
  (global-text-scale-mode -1)
  (setq-default fci-rule-column 80)
  (fci-mode 1))
(bind-key "C-c 0" 'reset-font-size)

(defun increase-font-size ()
  "Increase font size by 1."
  (interactive)
  (fci-mode 0)
  (global-text-scale-adjust 1)
  ;;(setq-default fci-rule-column 100)
  ;;(fci-mode 1)
  )
(bind-key "C-c +" 'increase-font-size)

(defun decrease-font-size ()
  "Decrease font size by 1."
  (interactive)
  (fci-mode 0)
  (global-text-scale-adjust -1)
  ;;(setq-default fci-rule-column 70)
  ;;(fci-mode 1))
  )
(bind-key "C-c -" 'decrease-font-size)

(defun get-github-url ()
  "Return the Github url for the current line."
  (defvar github-url)
  (setq github-url
   (s-concat
    "https://github.com/percolate/hotlanta/blob/master/"
    (s-chop-prefix
     "/Users/nayefcopty/Documents/Percolate/devolate/hotlanta/" buffer-file-name)
    "#L"
    (number-to-string (line-number-at-pos)))))

(defun copy-hotlanta-github-url ()
  "Put hotlanta URL for the line at point in kill ring."
  (interactive)
  (kill-new (get-github-url))
  (message "Copied: %s" (get-github-url)))
(bind-key "C-x a u" 'copy-hotlanta-github-url)

(provide 'misc)
;;; misc.el ends here
