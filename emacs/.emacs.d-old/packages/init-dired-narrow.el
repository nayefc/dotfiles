;;; package -- Summary:
;;; Commentary:
;;; Code:

(use-package dired-narrow
  :ensure t
  :bind (:map dired-mode-map
              ("/" . dired-narrow)))

(provide 'init-dired-narrow)
;;; init-dired-narrow.el ends here
