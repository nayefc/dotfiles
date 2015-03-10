;;; package --- Summary
;;; Commentary:

;;; Code:

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; (add-to-list 'load-path "~/.cask/cask.el")
;; (require 'cask)
;; (cask-initialize)

;; (load-local "defuns") ; https://github.com/rejeep/emacs/blob/master/defuns.el
;; (load-local "misc")
;; (when (eq system-type 'darwin)
;;     (load-local "osx"))

(require 'use-package)

;;;_. Theme, look and feel

(use-package solarized-theme
  :ensure t
  :if (featurep 'ns-win)  ; check if we're on OSX
  :init
  (progn
    ;; Disable scroll bar
    (scroll-bar-mode -1)

    ;; Bring OS X Emacs in line with shell setup
    (exec-path-from-shell-initialize)

    ;; Load theme
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
     '(default ((t (:height 150 :width normal :family "Monaco")))))))

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

;; Remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;;;_. General Settings and Modes

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


;;;_. Keybindings

;; buffer-move
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; Default search to regexp search
(global-set-key (kbd "C-s") 'isearch-forward-regexp)

;; Scroll other window up
(global-set-key (kbd "C-c p") 'scroll-other-window-down)
(global-set-key (kbd "C-c n") 'scroll-other-window)

;; Go to line
(global-set-key "\M-1" `goto-line)

;; Kill current line
(global-set-key (kbd "C-c d") 'kill-whole-line)

;; Copy line
(defun copy-line ()
  "Copy the current line."
  (interactive)
  (save-excursion
    (back-to-indentation)
    (kill-ring-save
     (point)
     (line-end-position)))
  (message "1 line copied"))
(global-set-key (kbd "C-x c") 'copy-line)

;; Duplicate a line
(defun duplicate-line ()
  "Duplicate current line to the line below and preserve indentation."
  (interactive)
  (beginning-of-line)
  (push-mark)
  (end-of-line)
  (let ((str (buffer-substring (region-beginning) (region-end))))
    (insert
     (concat (if (= 0 (forward-line 1)) "" "\n") str "\n"))
    (forward-line -1)))
(global-set-key (kbd "C-c f") 'duplicate-line)

;; Mark whole line
(defun mark-line ()
  "Mark a line."
  (interactive)
  (back-to-indentation)
  (set-mark-command nil)
  (move-end-of-line nil)
  (message "Lined marked")
  (setq deactivate-mark nil))
(global-set-key (kbd "C-c l") 'mark-line)


;;;_. External packages

;; Highlight lines longer than 100 characters
(use-package fci-mode
  :ensure fill-column-indicator
  :defer f
  :init
  (progn
    (setq-default fci-rule-column 120)
    (setq fci-handle-truncate-lines nil)
    (define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
    (global-fci-mode 1))
  :config
  (defun auto-fci-mode (&optional unused)
  (if (> (window-width) fci-rule-column)
      (fci-mode 1)
    (fci-mode 0)))
  (add-hook 'after-change-major-mode-hook 'auto-fci-mode)
  (add-hook 'window-configuration-change-hook 'auto-fci-mode))

;; Disable fci when autocomplete is on the line, as fci breaks autocomplete.
(defun sanityinc/fci-enabled-p ()
  "From http://emacs.stackexchange.com/questions/147/how-can-i-get-a-ruler-at-column-80."
  (symbol-value 'fci-mode))
(defvar sanityinc/fci-mode-suppressed nil)
(make-variable-buffer-local 'sanityinc/fci-mode-suppressed)
(defadvice popup-create (before suppress-fci-mode activate)
  "Suspend fci-mode while popups are visible."
  (let ((fci-enabled (sanityinc/fci-enabled-p)))
    (when fci-enabled
      (setq sanityinc/fci-mode-suppressed fci-enabled)
      (turn-off-fci-mode))))
(defadvice popup-delete (after restore-fci-mode activate)
  "Restore fci-mode when all popups have closed."
  (when (and sanityinc/fci-mode-suppressed
	     (null popup-instances))
    (setq sanityinc/fci-mode-suppressed nil)
          (turn-on-fci-mode)))

;; Add Flycheck mode for syntax checking
(use-package flycheck
  :init
  (progn
    (setq flycheck-highlighting-mode 'lines)
    (setq flycheck-check-syntax-automatically '(mode-enabled new-line idle-change))
    (setq flycheck-idle-change-delay 1))
  :idle (global-flycheck-mode)
  :config
  (progn
    (set-face-attribute 'flycheck-error nil :foreground "yellow" :background "red")
    (set-face-attribute 'flycheck-warning nil :foreground "red" :background "yellow")
    (set-face-attribute 'flycheck-info nil :foreground "red" :background "yellow")))

;; Jedi setup for python auto complete
(use-package jedi
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :commands jedi:setup
  :bind (("C-c k" . jedi:goto-definition)
	 ("C-c j" . jedi:goto-definition-pop-marker)
	 ("C-c ?" . jedi:show-doc))
  :config
  (progn
    (setq jedi:complete-on-dot t)
    (setq jedi:tooltip-method '(pos-tip))))  ; options '(pos-tip popup)

;; Pairing parentheses
(use-package autopair
  :ensure t
  :init
  (progn
    (add-hook 'c-mode-common-hook #'(lambda () (autopair-mode)))
    (add-hook 'python-mode-hook #'(lambda () (autopair-mode)))))

;; Fiplr
(use-package fiplr
  :ensure t
  :idle
  :bind ("C-x f" . fiplr-find-file)
  :init
  (progn
    (setq fiplr-ignored-globs '((directories (".git" ".svn"))
				(files ("*.jpg" "*.png" "*.zip" "*~" "*.pyc"))))))

;; git-commit-mode
(use-package git-commit-mode
  :ensure t
  :mode ("\\COMMIT_EDITMSG\\'" . git-commit-mode))

;; git-rebase-mode
(use-package git-rebase-mode
  :ensure t
  :defer t)

;; Magit
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :config
  (progn
    (defadvice magit-status (around magit-fullscreen activate)
      (window-configuration-to-register :magit-fullscreen)
      ad-do-it
      (delete-other-windows))

    (defun magit-quit-session ()
      "Restores the previous window configuration and kills the magit buffer"
      (interactive)
      (kill-buffer)
      (jump-to-register :magit-fullscreen))

    (bind-key "q" 'magit-quit-session magit-status-mode-map)))

;; Add Ace Jump Mode
(use-package ace-jump-mode
  :ensure t
  :idle
  :bind ("C-c SPC" . ace-jump-mode))

;; Add Ace Jump Buffer
(use-package ace-jump-buffer
  :ensure t
  :idle
  :bind ("C-," . ace-jump-buffer))

;; Multiple Cursors
(use-package multiple-cursors
  :ensure t
  :idle
  :bind (("C-c ." . mc/mark-next-like-this)
         ("C-c ," . mc/mark-previous-like-this)
         ("C-c c" . mc/edit-lines)
         ("C-c /" . mc/mark-all-like-this)))

;; Expand Region
(use-package expand-region
  ensure t
  :idle
  :bind ("C-c m" . er/expand-region))


;;;_. Language mode settings

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

;; Set default indent to 4
(setq-default c-basic-offset 2)

;; Set python indent to 4
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq python-indent 4)))

;; Insert ipdb in python shortcut
(defun python-add-breakpoint ()
  (interactive)
  (move-beginning-of-line nil)
  (indent-for-tab-command)
  (insert "import ipdb; ipdb.set_trace()")
  (newline-and-indent))
(define-key python-mode-map (kbd "C-c t") 'python-add-breakpoint)

;; Indent JavaScript to 2
(add-hook 'js-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq js-indent-level 2)))

;; Indent automatically in JavaScript
(add-hook 'js-mode-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))

;; Add dired-x mode to dired
(add-hook 'dired-load-hook
	  (lambda ()
	    (load "dired-x")))

(provide 'init)
;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
