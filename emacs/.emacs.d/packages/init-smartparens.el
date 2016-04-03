(use-package smartparens-config
  :ensure smartparens
  :diminish smartparens-mode
  :bind (("M-]" . sp-unwrap-sexp))
  ;; :bind (("C-c <right>" . sp-forward-slurp-sexp)
  ;; 	 ("C-c <left>" . sp-forward-barf-sexp))
  :config
  (require 'smartparens-config))

(add-hook 'python-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)

(setq sp-cancel-autoskip-on-backward-movement nil)

(--each '("python-mode" "python")
  (eval-after-load it '(require 'smartparens-python)))

(provide 'init-smartparens)
