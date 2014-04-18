(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; Remove top menu bar
(menu-bar-mode -1)

;; Prevent the cursor from blinking
(blink-cursor-mode 0)

;; Add Load Path Directory
(add-to-list 'load-path "~/.emacs.d/")

;; Highlight lines longer than 100 characters
(setq whitespace-line-column 100)
(setq whitespace-style '(face lines-tail trailing))
(global-whitespace-mode 1)

;; Show which function you're in
(which-function-mode)
(setq which-func-unknown "n/a")

;; Overwrite text when writing over a highlighted region
(delete-selection-mode t)

;; Add Flycheck mode for syntax checking
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-check-syntax-automatically '(mode-enabled new-line idle-change))
(setq flycheck-idle-change-delay 1)
(eval-after-load 'flycheck
    '(progn
      (set-face-attribute 'flycheck-warning nil
			  :foreground "yellow"
			  :background "red")))
(eval-after-load 'flycheck
    '(progn
      (set-face-attribute 'flycheck-error nil
			  :foreground "red"
			  :background "yellow")))

;; Fiplr -- requires emacs 24.3
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(setq fiplr-ignored-globs '((directories (".git" ".svn"))
			    (files ("*.jpg" "*.png" "*.zip" "*~" "*.pyc"))))

;; Remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Default search to regexp search
(global-set-key (kbd "C-s") 'isearch-forward-regexp)

;; Scroll other window up
(global-set-key (kbd "C-c p") 'scroll-other-window-down)
(global-set-key (kbd "C-c n") 'scroll-other-window)

;; Display line numbers
(global-linum-mode t)

;; Go to line bindinbg
(global-set-key "\M-1" `goto-line)

;; Use iswitch
(iswitchb-mode 1)
(setq iswitchb-buffer-ignore '("^ " "*"))

;; Display line numbers at the bottom
(setq line-number-mode t)

;; Add space on the margin for line numbering
(setq linum-format "%d ")

;; Scroll one line at a time
(setq scroll-step 1)

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
(require 'ace-jump-mode)
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
(require 'multiple-cursors)
(global-set-key (kbd "C-c c") 'mc/edit-lines)
(global-set-key (kbd "C-c .") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c ,") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c /") 'mc/mark-all-like-this)

;; Expand Region
(add-to-list 'load-path "~/.emacs.d/expand-region.el/")
(require 'expand-region)
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

;; Load ruby mode when a .rb file is opened
(autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts." t)
(setq auto-mode-alist  (cons '(".rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '(".rhtml$" . html-mode) auto-mode-alist))

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
(require 'haml-mode)
(add-hook 'haml-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (define-key haml-mode-map "\C-m" 'newline-and-indent)))

;; Set default indent to 4
(setq-default c-basic-offset 2)

;; Set python indent to 4
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq python-indent 4)))

;; Indent JavaScript to 2
(setq js-indent-level 2)

;; Indent automatically in JavaScript
(add-hook 'js-mode-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))
