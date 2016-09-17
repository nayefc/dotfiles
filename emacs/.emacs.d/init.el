;;; package --- Summary
;;; Commentary:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(exec-path-from-shell-check-startup-files nil)
 '(package-selected-packages
   (quote
    (pyenv-mode highlight-indentation company-jedi jedi expand-region company projectile helm-git-grep helm exec-path-from-shell fill-column-indicator git-gutter+ flycheck highlight-symbol multiple-cursors ace-window avy magit yaml-mode with-editor use-package sr-speedbar solarized-theme smartparens pallet magit-popup))))


;;; Code:

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(require 'cask "/usr/local/share/emacs/site-lisp/cask/cask.el")
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

;; ;; Load other init files
;; (use-package f)
;; (defun load-local (FILE)
;;   "Load FILE from Emacs directory."
;;   (load (f-expand FILE (f-join user-emacs-directory "packages"))))

(defconst is-a-mac
  (eq system-type 'darwin)
  "Is this running on OS X?")

(use-package init-default-settings
  :load-path "packages/")
(use-package init-default-editing
  :load-path "packages/")
(use-package init-helper-functions
  :load-path "packages/")
(use-package init-gui
  :load-path "packages/"
  :if is-a-mac)
(use-package init-magit
  :load-path "packages/")
(use-package init-avy
  :load-path "packages/")
(use-package init-ace-window
  :load-path "packages/")
(use-package init-multiple-cursors
  :load-path "packages/")
(use-package init-highlight-symbol
  :load-path "packages/")
(use-package init-flycheck
  :load-path "packages/")
(use-package init-git-gutter
  :load-path "packages/")
(use-package init-fci-mode
  :load-path "packages/")
(use-package init-exec-path-from-shell
  :load-path "packages/")
(use-package init-helm
  :load-path "packages/")
(use-package init-projectile
  :load-path "packages/")
(use-package init-company
  :load-path "packages/")
(use-package init-smartparens
  :load-path "packages/")

;; python packages
(use-package init-expand-region
  :load-path "packages/python")
(use-package init-jedi
  :load-path "packages/python")
(use-package init-highlight-indentation
  :load-path "packages/python")
(use-package init-python
  :load-path "packages/python")

(provide 'init)
;;; init.el ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#002b36" :foreground "#839496" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :foundry "nil" :family "InconsolataGo")))))
