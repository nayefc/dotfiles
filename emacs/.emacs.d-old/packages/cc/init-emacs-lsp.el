;; (use-package lsp-mode
;;   :commands lsp :ensure t)

;; (use-package lsp-ui
;;   :commands lsp-ui-mode
;;   :ensure t)

;; (use-package company-lsp
;;   :ensure t
;;   :commands company-lsp
;;   :config (push 'company-lsp company-backends)) ;; add company-lsp as a backend

;; (use-package ccls
;;   :ensure t
;;   :config
;;   (setq ccls-executable "ccls")
;;   (setq lsp-prefer-flymake nil)
;;   (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
;;   :hook ((c-mode c++-mode objc-mode) .
;;          (lambda () (require 'ccls) (lsp))))

(provide 'init-emacs-lsp)
