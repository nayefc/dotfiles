;;; package --- Summary
;;; Commentary:

;;; Code:

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

; check if we're on OSX
(when (featurep 'ns-win)

  ;; Disable scroll bar
  (scroll-bar-mode -1)

  ;; Bring OS X Emacs in line with shell setup
  (exec-path-from-shell-initialize)

  ;; Load solarized theme
  (load-theme 'solarized-dark t)

  ;; make the fringe stand out from the background
  (setq solarized-distinct-fringe-background t)

  ;; make the modeline high contrast
  (setq solarized-high-contrast-mode-line t)

  ;; Use less bolding
  (setq solarized-use-less-bold t)

  ;; Use more italics
  (setq solarized-use-more-italic t)

  ;; Use less colors for indicators such as git:gutter, flycheck and similar.
  (setq solarized-emphasize-indicators nil)

  (setq x-underline-at-descent-line t)

  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(custom-safe-themes (quote ("e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e"
				"d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879"
				"8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4"
				default))))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   ; '(default ((t (:height 150 :width normal :family "Terminus"))))
   '(default ((t (:height 150 :width normal :family "Monaco"))))))

;; Disable source control hooks (i.e: vc-git)
(setq vc-handled-backends nil)

;; Activate pyenv-mode
(pyenv-mode)

;; Remove top menu bar
(menu-bar-mode -1)

;; Turn on icomplete-mode, replacing iswitch for v24.4
(icomplete-mode 1)

;; buffer-move
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; Highlight lines longer than 100 characters
; (setq whitespace-line-column 100)
; (setq whitespace-style '(face lines-tail trailing))
; (global-whitespace-mode 1)

;; Set 100 column marker
; http://www.emacswiki.org/emacs-en/FillColumnIndicator
(setq-default fci-rule-column 100)
(setq fci-handle-truncate-lines nil)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)
(defun auto-fci-mode (&optional unused)
  (if (> (window-width) fci-rule-column)
      (fci-mode 1)
    (fci-mode 0))
  )
(add-hook 'after-change-major-mode-hook 'auto-fci-mode)
(add-hook 'window-configuration-change-hook 'auto-fci-mode)

;; Show which function you're in
(which-function-mode)
(setq which-func-unknown "n/a")

;; Overwrite text when writing over a highlighted region
(delete-selection-mode t)

;; Add Flycheck mode for syntax checking
(add-hook 'after-init-hook 'global-flycheck-mode)
(setq flycheck-highlighting-mode 'lines)
(setq flycheck-check-syntax-automatically '(mode-enabled new-line idle-change))
(setq flycheck-idle-change-delay 1)
(eval-after-load 'flycheck
    '(progn
      (set-face-attribute 'flycheck-error nil
			  :foreground "yellow"
			  :background "red")))
(eval-after-load 'flycheck
    '(progn
      (set-face-attribute 'flycheck-warning nil
			  :foreground "red"
			  :background "yellow")))
(eval-after-load 'flycheck
    '(progn
      (set-face-attribute 'flycheck-info nil
			  :foreground "red"
			  :background "yellow")))

;; Fiplr -- requires emacs 24.3
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(setq fiplr-ignored-globs '((directories (".git" ".svn"))
			    (files ("*.jpg" "*.png" "*.zip" "*~" "*.pyc"))))

;; Auto load git-commit-mode
(add-to-list 'auto-mode-alist '("\\COMMIT_EDITMSG\\'" . git-commit-mode))

;; Key binding for magit-status
(global-set-key (kbd "C-x g") 'magit-status)

;; Remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Default search to regexp search
(global-set-key (kbd "C-s") 'isearch-forward-regexp)

;; Scroll other window up
(global-set-key (kbd "C-c p") 'scroll-other-window-down)
(global-set-key (kbd "C-c n") 'scroll-other-window)

;; Display line numbers
(global-linum-mode t)

;; Go to line
(global-set-key "\M-1" `goto-line)

;; Display line numbers at the bottom
(setq line-number-mode t)

;; Add space on the margin for line numbering
(setq linum-format "%d ")

;; Scroll one line at a time
(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)
(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; Remove Emacs startup screen
(setq inhibit-startup-screen +1)

;; Buffer name for for two files in different directories shows full path instead of <2>
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Highlight parenthesis matching pair
(show-paren-mode 1)

;; Put all emacs backup files in one directory
(setq backup-directory-alist `(("." . "~/.saves")))

;; Kill current line
(global-set-key (kbd "C-c d") 'kill-whole-line)

;; Copy line
(defun copy-line ()
  (interactive)
  (save-excursion
    (back-to-indentation)
    (kill-ring-save
     (point)
     (line-end-position)))
  (message "1 line copied"))
(global-set-key (kbd "C-x c") 'copy-line)

;; Copy and paste line below
; This unbinds C-c C-c python-send-buffer first
; but I no longer use C-c C-c for duplicating a line
;; (add-hook 'python-mode-hook
;; 	  (lambda()
;; 	    (local-unset-key (kbd "C-c C-c"))))
(global-set-key (kbd "C-c f") "\C-a\C- \C-n\M-w\C-y")

;; Add AceJump Mode
(add-to-list 'load-path "~/.emacs.d/ace-jump-mode/")
(autoload 'ace-jump-mode "ace-jump-mode.el" "Ace jump mode")
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; Automatically indent on new line
(defun newline-indents ()
  "Bind Return to `newline-and-indent' in the local keymap."
  (local-set-key "\C-m" 'newline-and-indent))

;; Multiple Cursors
(add-to-list 'load-path "~/.emacs.d/multiple-cursors.el/")
(global-set-key (kbd "C-c c") 'mc/edit-lines)
(global-set-key (kbd "C-c .") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c ,") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c /") 'mc/mark-all-like-this)
(autoload 'mc/edit-lines "mc-edit-lines" "" t)
(autoload 'mc/mark-next-like-this "mc-mark-more" "" t)
(autoload 'mc/mark-previous-like-this "mc-mark-more" "" t)
(autoload 'mc/mark-all-like-this "mc-mark-more" "" t)

;; Expand Region
(add-to-list 'load-path "~/.emacs.d/expand-region.el/")
(require 'expand-region) ;; do not autoload, breaks fiplr for some reason.
(global-set-key (kbd "C-c m") 'er/expand-region)

;; Tell Emacs to use the function above in certain editing modes.
(add-hook 'lisp-mode-hook             (function newline-indents))
(add-hook 'emacs-lisp-mode-hook       (function newline-indents))
(add-hook 'lisp-interaction-mode-hook (function newline-indents))
(add-hook 'scheme-mode-hook           (function newline-indents))
(add-hook 'c-mode-hook                (function newline-indents))
(add-hook 'c++-mode-hook              (function newline-indents))
(add-hook 'java-mode-hook             (function newline-indents))
(add-hook 'python-mode-hook           (function newline-indents))

;; Add dired-x mode to dired
(add-hook 'dired-load-hook
	  (lambda ()
	    (load "dired-x")))

;; Load ruby mode when a .rb file is opened
(autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts." t)
(setq auto-mode-alist  (cons '(".rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '(".rhtml$" . html-mode) auto-mode-alist))

(add-to-list 'load-path "~/.emacs.d/ruby-electric/")
(add-hook 'ruby-mode-hook
	  (lambda()
	    (add-hook 'local-write-file-hooks
		      '(lambda()
			 (save-excursion
			   (untabify (point-min) (point-max))
			   (delete-trailing-whitespace)
			   )))
	    (set (make-local-variable 'indent-tabs-mode) 'nil)
	    (set (make-local-variable 'tab-width) 2)
	    (imenu-add-to-menubar "IMENU")
	    (define-key ruby-mode-map "\C-m" 'newline-and-indent)
	    (require 'ruby-electric)
	    (ruby-electric-mode t)))

;; Add Haml Support
(add-to-list 'load-path "~/.emacs.d/haml-mode/")
(autoload 'haml-mode "haml-mode.el" "Mode for Haml file" t)
(add-hook 'haml-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (define-key haml-mode-map "\C-m" 'newline-and-indent)))

;; Insert ipdb in python shortcut
(defun python-add-breakpoint ()
  (interactive)
  (move-beginning-of-line nil)
  (insert "import ipdb; ipdb.set_trace()")
  (newline-and-indent))
(define-key python-mode-map (kbd "C-c t") 'python-add-breakpoint)

;; Set default indent to 4
(setq-default c-basic-offset 2)

;; Set python indent to 4
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq python-indent 4)))

;; Indent JavaScript to 2
(add-hook 'js-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq js-indent-level 2)))

;; Indent automatically in JavaScript
(add-hook 'js-mode-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))

(provide 'init)
;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
