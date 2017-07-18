;;; package --- Summary
;;; Commentary:

;;; Code:

(require 'package)
(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("gnu" . "http://elpa.gnu.org/packages/"))
      package-archive-priorities '(("melpa" . 10)
				   ("melpa-stable" . 5)
				   ("gnu" . 0)))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (message "hi")
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'diminish)                ;; if you use :diminish
(require 'bind-key)                ;; if you use any :bind variant

(defconst is-a-mac
  (eq system-type 'darwin)
  "Is this running on OS X?")

;; Default value for :pin
(setq use-package-always-pin "melpa")

(use-package init-default-settings
  :load-path "packages/")
(use-package init-default-editing
  :load-path "packages/")
(use-package init-dired
  :load-path "packages/")
(use-package init-hydra
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
(use-package init-ivy
  :load-path "packages/")
(use-package init-projectile
  :load-path "packages/")
(use-package init-counsel-projectile
  :load-path "packages/")
(use-package init-company
  :load-path "packages/")
(use-package init-smartparens
  :load-path "packages/")
(use-package init-dashboard
  :load-path "packages/")
(use-package init-dumb-jump
  :load-path "packages/")
(use-package init-golden-ratio-scroll-screen
  :load-path "packages/")
(use-package init-indent-tools
  :load-path "packages/")
(use-package init-ansi-term
  :load-path "packages/")
(use-package init-all-the-icons
  :load-path "packages/")
(use-package init-neotree
  :load-path "packages/")
(use-package init-eshell
  :load-path "packages/")
(use-package init-shell
  :load-path "packages/")
(use-package init-shx
  :load-path "packages/")
(use-package init-zen-mode
  :load-path "packages/")

;; (load-file "~/.emacs.d/packages/kite.el")

;; python packages
(use-package init-expand-region
  :load-path "packages/python")
(use-package init-jedi
  :load-path "packages/python")
(use-package init-highlight-indentation
  :load-path "packages/python")
(use-package init-python
  :load-path "packages/python")

;; c++ packages
(use-package init-irony
  :load-path "packages/cc")
(use-package init-cc
  :load-path "packages/cc")
;; (use-package init-rtags
;;   :load-path "packages/cc"
;;   :if is-a-mac)

(provide 'init)
;;; init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(exec-path-from-shell-check-startup-files nil)
 '(package-selected-packages
   (quote
    (elisp--witness--lisp string-inflection shx
			  (progn t elisp--witness--lisp)
			  smartparens ivy-rtags rtags all-the-icons-ivy protobuf-mode golden-ratio-scroll-screen all-the-icons all-the-icons-dired neotree ivy-hydra indent-tools irony projectile-speedbar project-explorer ag dumb-jump dashboard flycheck-irony counsel-projectile company-irony-c-headers company-irony google-c-style ivy virtualenvwrapper buffer-move pylint highlight-indentation company-jedi jedi expand-region company projectile exec-path-from-shell fill-column-indicator git-gutter+ flycheck highlight-symbol multiple-cursors ace-window avy magit yaml-mode with-editor use-package sr-speedbar solarized-theme pallet magit-popup))))

;; Font height 135 or 130
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :foreground "#839496" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 135 :width normal :foundry "nil" :family "InconsolataGo"))))
 '(ivy-current-match ((t (:background "#436060"))))
 '(ivy-modified-buffer ((t (:foreground "#ff7777"))))
 '(swiper-match-face-1 ((t (:background "#d33682" :foreground "#002b36" :weight bold))))
 '(swiper-match-face-2 ((t (:background "#d33682" :foreground "#002b36" :weight bold))))
 '(swiper-match-face-3 ((t (:background "#d33682" :foreground "#002b36" :weight bold))))
 '(swiper-match-face-4 ((t (:background "#d33682" :foreground "#002b36" :weight bold)))))
