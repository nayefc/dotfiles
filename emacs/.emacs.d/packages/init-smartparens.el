;;(add-to-list 'load-path "~/dotfiles/emacs/.emacs.d/packages")
(add-to-list 'load-path "~/dotfiles/emacs/.emacs.d/packages/smartparens-1.10.1")
(load "smartparens")

(use-package smartparens-config
  :ensure smartparens
  :diminish smartparens-mode
  :bind (("M-]" . sp-unwrap-sexp))
  :config
  (require 'smartparens-config))

(add-hook 'python-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'c++-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'c-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)

(setq sp-cancel-autoskip-on-backward-movement nil)

;; sp-delete, sp-for, sp-back
;; M-x sp-cheat-sheet
;; sp-forward-slurp-sexp C-c <right>
;; sp-forward-barf-sexp C-c <left>

(provide 'init-smartparens)
