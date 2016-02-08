(use-package smartparens-config
  :ensure smartparens
  :diminish smartparens-mode
  :config
  (require 'smartparens-config))

(add-hook 'python-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)

(--each '("python-mode" "python")
  (eval-after-load it '(require 'smartparens-python)))

(provide 'init-smartparens)
