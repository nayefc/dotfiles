(use-package indent-tools
  :ensure t
  :diminish indent-tools-minor-mode
  :init
  :config
  (add-hook 'python-mode-hook
            (lambda () (define-key python-mode-map (kbd "C-c >") 'indent-tools-hydra/body))))

(provide 'init-indent-tools)
