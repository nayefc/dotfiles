;; Add Load Path Directory
(add-to-list 'load-path "~/.emacs.d/")

;;(global-menu-bar-mode t)

;; Scroll other window up
(global-set-key (kbd "C-c p") 'scroll-other-window-down)
(global-set-key (kbd "C-c n") 'scroll-other-window)

;; Display line numbers
(global-linum-mode t)

;; Use iswitch
(iswitchb-mode 1)
(setq iswitchb-buffer-ignore '("^ " "*"))

;; Display line numbers at the bottom
(setq line-number-mode t)

;; Add space on the margin for line numbering
(setq linum-format "%d ")

;; Scroll one line at a time
(setq scroll-step 1)

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

;; Go to line bindinbg
(global-set-key "\M-1" `goto-line)

;; Set default indent to 4
(setq-default c-basic-offset 2)

;; Indent JavaScript to 2
(setq js-indent-level 2)

;; Indent automatically in JavaScript
(add-hook 'js-mode-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))
