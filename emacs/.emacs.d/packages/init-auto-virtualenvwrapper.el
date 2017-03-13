(use-package auto-virtualenvwrapper
  :ensure t
  :init
  (add-hook 'python-mode-hook #'auto-virtualenvwrapper-activate)
  ;; Activate on changing buffers
  (add-hook 'window-configuration-change-hook #'auto-virtualenvwrapper-activate)
  ;; Activate on focus in
  (add-hook 'focus-in-hook #'auto-virtualenvwrapper-activate))

(provide 'init-auto-virtualenvwrapper)
