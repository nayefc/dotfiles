(use-package company
  :ensure t
  :bind ("C-;" . company-complete-common)
  :init
  (global-company-mode)
  :config
  (delete 'company-backends 'company-clang))

(provide 'init-company)
