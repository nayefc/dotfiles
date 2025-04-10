;;; package --- Summary
;;; Commentary:
;;; Code:

(use-package company-tabnine
  :ensure t
  :init
  (require 'company-tabnine)
  :config
  ;; Trigger completion immediately.
  (setq company-idle-delay 0)

  ;; Number the candidates (use M-1, M-2 etc to select completions).
  (setq company-show-numbers t)

  ;; Use the tab-and-go frontend.
  ;; Allows TAB to select and complete at the same time.
  (company-tng-configure-default)
  (setq company-frontends
	'(company-tng-frontend
          company-pseudo-tooltip-frontend
          company-echo-metadata-frontend)))

(provide 'init-tabnine)
;;; init-tabnine.el ends here
