;;; package -- Summary

;;; Commentary:

(use-package virtualenvwrapper
  :ensure t
  :bind (("C-c C-d" . venv-workon)))

;; (bind-key "C-c C-d" 'venv-workon)

(provide 'init-venv)
