;;; package --- Summary
;;; Commentary:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
'(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 140 :width normal :foundry "nil" :family "*-Inconsolata-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1")))))

;; Code:

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(require 'cask "/Users/nayefcopty/dotfiles/emacs/.emacs.d/.cask/24.5.1/elpa/cask-20151123.528/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

;; Bootstrap use-package
(eval-when-compile
  (require 'use-package))
(require 'diminish)                ;; if you use :diminish
(require 'bind-key)                ;; if you use any :bind variant

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package f)

(defun load-local (FILE)
  "Load FILE from Emacs directory."
  (load (f-expand FILE user-emacs-directory)))

(load-local "misc")
(load-local "keybindings")
(load-local "languages")
(when (eq system-type 'darwin)
  (load-local "osx"))

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
  :defines fci-column-indicator fci-handle-truncate-lines fci-rule-column
  :init
  (progn
    (add-hook 'c-mode-hook 'fci-mode)
    (add-hook 'python-mode-hook 'fci-mode)
    (add-hook 'ruby-mode-hook 'fci-mode)
    (add-hook 'emacs-lisp-mode-hook 'fci-mode)
    (setq fci-rule-column 80)
    (setq fci-column-indicator 80)
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
    (add-to-list 'company-backends '(company-jedi company-files))))

(use-package autopair
  :ensure t
  :init
  (progn
    (add-hook 'c-mode-common-hook #'(lambda () (autopair-mode)))
    (add-hook 'python-mode-hook #'(lambda () (autopair-mode)))))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :defines magit-last-seen-setup-instructions
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

(use-package avy
  :ensure t
  :bind (("C-;" . avy-goto-char)
	 ("C-'" . avy-goto-word-1)
	 ("M-1" . avy-goto-line))
  :init
  (progn
    (setq avy-background t)
    (setq avy-keys (number-sequence ?a ?z))))

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
  :defines helm-ff-search-library-in-sexp helm-ff-file-name-history-use-recentf helm-buffers-fuzzy-matching
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

(use-package git-gutter+
  :ensure t
  :init (global-git-gutter+-mode)
  :config
  (progn
    (define-key git-gutter+-mode-map (kbd "C-x n") 'git-gutter+-next-hunk)
    (define-key git-gutter+-mode-map (kbd "C-x p") 'git-gutter+-previous-hunk)
    ;; (define-key git-gutter+-mode-map (kbd "C-x v =") 'git-gutter+-show-hunk)
    ;; (define-key git-gutter+-mode-map (kbd "C-x r") 'git-gutter+-revert-hunks)
    (define-key git-gutter+-mode-map (kbd "C-x t") 'git-gutter+-stage-hunks)
    ;; (define-key git-gutter+-mode-map (kbd "C-x c") 'git-gutter+-commit)
    ;; x(define-key git-gutter+-mode-map (kbd "C-x t") 'git-gutter+-commit)
    (define-key git-gutter+-mode-map (kbd "C-x a c") 'git-gutter+-stage-and-commit)
    ;; (define-key git-gutter+-mode-map (kbd "C-x C-y") 'git-gutter+-stage-and-commit-whole-buffer)
    ;; (define-key git-gutter+-mode-map (kbd "C-x U") 'git-gutter+-unstage-whole-buffer))
    :diminish (git-gutter+-mode "gg")))

(provide 'init)
;;; init.el ends here
