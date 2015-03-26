;;; package --- Summary
;;; Commentary:

;;; Code:

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(require 'cask "/usr/local/share/emacs/site-lisp/cask.el")
(cask-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(use-package f)

(defun load-local (FILE)
  "Load FILE from Emacs directory."
  (load (f-expand FILE user-emacs-directory)))

(load-local "misc")
(load-local "keybindings")
(load-local "languages")
(when (eq system-type 'darwin)
  (load-local "osx"))

;;;; External packages

;; Draw ruler on column
(use-package fci-mode
  :ensure fill-column-indicator
  :defer f
  :init
  (progn
    (setq-default fci-rule-column 80)
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

(use-package jedi
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :commands jedi:setup
  :init
  (setq jedi:server-command '("/Users/nayefcopty/dotfiles/emacs/emacs-jedi/jediepcserver.py"))
  :bind (("C-c k" . jedi:goto-definition)
	 ("C-c j" . jedi:goto-definition-pop-marker)
	 ("C-c ?" . jedi:show-doc))
  :config
  (progn
    (setq jedi:complete-on-dot t)
    (setq jedi:tooltip-method '(pos-tip))))  ; options '(pos-tip popup)

(use-package autopair
  :ensure t
  :init
  (progn
    (add-hook 'c-mode-common-hook #'(lambda () (autopair-mode)))
    (add-hook 'python-mode-hook #'(lambda () (autopair-mode)))))

(use-package fiplr
  :ensure t
  :idle
  :bind ("C-x f" . fiplr-find-file)
  :init
  (progn
    (setq fiplr-ignored-globs '((directories (".git" ".svn"))
				(files ("*.jpg" "*.png" "*.zip" "*~" "*.pyc"))))))

(use-package git-commit-mode
  :ensure t
  :mode ("\\COMMIT_EDITMSG\\'" . git-commit-mode))

(use-package git-rebase-mode
  :ensure t
  :defer t)

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

(use-package ace-jump-buffer
  :ensure t
  :idle
  :bind ("C-," . ace-jump-buffer))

(use-package multiple-cursors
  :ensure t
  :idle
  :bind (("C-c ." . mc/mark-next-like-this)
         ("C-c ," . mc/mark-previous-like-this)
         ("C-c c" . mc/edit-lines)
         ("C-c /" . mc/mark-all-like-this)))

(use-package expand-region
  ensure t
  :idle
  :bind ("C-c m" . er/expand-region))

(provide 'init)
;;; init.el ends here
