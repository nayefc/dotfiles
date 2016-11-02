(use-package smartparens-config
  :ensure smartparens
  :diminish smartparens-mode
  :bind (("M-]" . sp-unwrap-sexp))
  ;; :bind (("C-c <right>" . sp-forward-slurp-sexp)
  ;; 	 ("C-c <left>" . sp-forward-barf-sexp))
  :config
  (require 'smartparens-config))

(add-hook 'python-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'c++-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'c-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)

(setq sp-cancel-autoskip-on-backward-movement nil)

(add-hook 'c++-mode-hook #'smartparens-mode)
(add-hook 'python-mode-hook #'smartparens-mode)

(provide 'init-smartparens)
