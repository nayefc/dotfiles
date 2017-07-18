(use-package smartparens
  :ensure t
  :pin melpa-stable
  :diminish smartparens-mode
  :bind (("M-]" . sp-unwrap-sexp)
	 ("C-M-f" . sp-forward-sexp)
	 ("C-M-b" . sp-backward-sexp)
	 ("C-M-<right>" . sp-forward-slurp-sexp)
	 ("C-M-<left>" . sp-backward-slurp-sexp))
  	 ;; ("C-<right>" . sp-forward-barf-sexp)
	 ;; ("C-<left>" . sp-backward-barf-sexp)
  :config
  (require 'smartparens-config)
  (add-hook 'python-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'c++-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'c-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)
  (setq sp-cancel-autoskip-on-backward-movement nil))

(provide 'init-smartparens)
