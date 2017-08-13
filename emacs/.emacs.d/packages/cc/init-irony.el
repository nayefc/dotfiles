;;; package --- Summary
;;; Commentary:
;;; Code:

(use-package irony
  :ensure t
  :mode (("\\.cc\\'" . c++-mode)
         ("\\.cpp\\'" . c++-mode)
         ("\\.h\\'" . c++-mode)
         ("\\.c\\'" . c-mode)))

(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'c-mode-common-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(use-package company-irony
  :ensure t
  :config
  (add-to-list 'company-backends 'company-irony))

(use-package company-irony-c-headers
  :ensure t
  :config
  (add-to-list 'company-backends 'company-irony-c-headers))

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(provide 'init-irony)
;;; init-irony.el ends here
