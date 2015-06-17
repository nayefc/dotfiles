;;; package --- Summary
;;; Commentary:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 150 :width normal :family "Monaco")))))

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

;;;; temp

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

;;;; External packages

(use-package exec-path-from-shell-initialize)

;; Draw ruler on column
(use-package fci-mode
  :ensure fill-column-indicator
  :defer t
  :init
  (add-hook 'c-mode-hook 'fci-mode)
  (add-hook 'python-mode-hook 'fci-mode)
  (add-hook 'ruby-mode-hook 'fci-mode)
  (add-hook 'emacs-lisp-mode-hook 'fci-mode)
  :config
  (progn
    (setq-default fci-rule-column 80)
    (setq fci-handle-truncate-lines nil)
    (defun auto-fci-mode (&optional unused)
      (if (> (window-width) fci-rule-column)
	  (fci-mode 1)
	(fci-mode 0)))
    (add-hook 'after-change-major-mode-hook 'auto-fci-mode)
    (add-hook 'window-configuration-change-hook 'auto-fci-mode)))

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

(use-package pyenv-mode)

(use-package flycheck
  :ensure t
  :init
  (progn
    (global-flycheck-mode)
    (setq flycheck-highlighting-mode 'lines)
    (setq flycheck-check-syntax-automatically '(mode-enabled new-line idle-change))
    (setq flycheck-idle-change-delay 1))
  :config
  (progn
    (set-face-attribute 'flycheck-error nil :foreground "yellow" :background "red")
    (set-face-attribute 'flycheck-warning nil :foreground "red" :background "yellow")
    (set-face-attribute 'flycheck-info nil :foreground "red" :background "yellow")))

(defun jedi:goto-definition-same-frame ()
  "Jedi goto-definition wrapper to go to definition directly."
  (interactive)
  (jedi:goto-definition nil `definition))

(defun jedi:goto-definition-new-frame ()
  "Jedi goto-definition wrapper in a new, nexts frame."
  (interactive)
  (jedi:goto-definition 1 `definition))

(use-package jedi
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :commands jedi:setup
  :bind (("C-c k" . jedi:goto-definition-same-frame)
	 ("C-c ;" . jedi:goto-definition-new-frame)
	 ("C-c '" . jedi:goto-definition)
	 ("C-c j" . jedi:goto-definition-pop-marker)
	 ("C-c ?" . jedi:show-doc)
	 ("C-c \\" . helm-jedi-related-names))
  :init
  (progn
    (setq jedi:server-command '("/Users/nayefcopty/dotfiles/emacs/emacs-jedi/jediepcserver.py"))
    (add-hook 'python-mode-hook 'jedi:setup)
    (setq jedi:complete-on-dot t)
    (setq jedi:tooltip-method '(pos-tip)))
  :config
  (progn
    (define-key jedi-mode-map (kbd "C-c .") nil)
    (define-key jedi-mode-map (kbd "C-c ,") nil)
    (define-key jedi-mode-map (kbd "C-c /") nil)))

(use-package company
  :ensure t
  :defer t
  :init
  (global-company-mode))

(use-package company-jedi
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :init
  (progn
    ;(add-to-list 'company-backends 'company-jedi)
    (add-to-list 'company-backends '(company-jedi company-files))))

(use-package autopair
  :ensure t
  :init
  (progn
    (add-hook 'c-mode-common-hook #'(lambda () (autopair-mode)))
    (add-hook 'python-mode-hook #'(lambda () (autopair-mode)))))

(use-package git-commit-mode
  :ensure t
  :mode ("\\COMMIT_EDITMSG\\'" . git-commit-mode))

(use-package git-rebase-mode
  :ensure t
  :defer t)

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :init
  (progn
    ;; (setq magit-auto-revert-mode nil)
    (setq magit-last-seen-setup-instructions "1.4.0"))
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
  :bind ("C-c SPC" . ace-jump-mode))

(use-package ace-window
  :ensure t
  :bind ("M-p" . ace-window)
  :init
  (progn
    ;(setq aw-background nil)
    (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))))

(use-package multiple-cursors
  :ensure t
  :bind (("C-c ." . mc/mark-next-like-this)
         ("C-c ," . mc/mark-previous-like-this)
         ("C-c c" . mc/edit-lines)
         ("C-c /" . mc/mark-all-like-this)))

(use-package expand-region
  :ensure t
  :bind ("C-c m" . er/expand-region))

(use-package helm
  :ensure t
  :commands helm-mode
  :bind (("M-x" . helm-M-x)
	 ("C-x b" . helm-buffers-list)
	 ("C-x f" . helm-projectile-find-file))
  :config
  (progn
    (helm-autoresize-mode 1)
    ; open helm buffer inside current window, not occupy whole other window
    (setq helm-split-window-in-side-p t
	  ; move to end or beginning of source when reaching top or bottom of source.
	  helm-move-to-line-cycle-in-source t
	  ; search for library in `require' and `declare-function' sexp.
	  helm-ff-search-library-in-sexp t
	  ; scroll 8 lines other window using M-<next>/M-<prior>
	  helm-scroll-amount 8
	  helm-ff-file-name-history-use-recentf t)

    ; rebind tab to run persistent action
    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
    ; make TAB works in terminal
    (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
    ; list actions using C-z
    (define-key helm-map (kbd "C-z")  'helm-select-action)

    (setq helm-buffers-fuzzy-matching t)))

(use-package helm-git-grep
  :ensure t
  :bind (("C-c g" . helm-git-grep)
	 ("C-c h" . helm-git-grep-at-point))
  :config
  (progn
    (eval-after-load 'helm
      '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm))))

(use-package helm-projectile
  :defer t)

(use-package projectile
  :ensure t
  :defer t
  :init
  (progn
    (helm-projectile-on)
    (projectile-global-mode)
    (setq projectile-completion-system 'helm)
    (setq projectile-switch-project-action 'projectile-dired)))

(use-package highlight-symbol
  :ensure t
  :defer t
  :bind (("C-c w" . highlight-symbol)
	 ("C-c a" . highlight-symbol-next)
	 ("C-c s" . highlight-symbol-prev)
	 ("C-c q" . highlight-symbol-remove-all))
  :config
  (progn
    (setq highlight-symbol-colors
	  '("DeepPink" "cyan" "MediumPurple1" "SpringGreen1"
	    "DarkOrange" "HotPink1" "RoyalBlue1" "OliveDrab"))))

(provide 'init)
;;; init.el ends here
