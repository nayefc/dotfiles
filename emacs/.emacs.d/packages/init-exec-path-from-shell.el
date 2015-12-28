(use-package exec-path-from-shell
  :ensure t
  :init
  (custom-set-variables
   '(exec-path-from-shell-check-startup-files nil))
  :config
  (exec-path-from-shell-initialize))

(provide 'init-exec-path-from-shell)
