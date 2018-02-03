;;; package --- Summary
;;; Commentary:
;;; Code:

(use-package f
  :ensure t)

(use-package clang-format
  :ensure t
  :init)

(defun clang-format-buffer-smart ()
  "Reformat buffer if .clang-format exists in the projectile root."
  (when  (eq major-mode 'c++-mode)
    (when (f-exists? (expand-file-name ".clang-format" (projectile-project-root)))
    (setq clang-format-style-option (expand-file-name ".clang-format" (projectile-project-root)))
    (clang-format-buffer))))

(add-hook 'c++-mode-hook
          (lambda () (add-hook 'before-save-hook 'clang-format-buffer-smart 'local)))

(provide 'init-cc-clang-format)
