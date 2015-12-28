(use-package autopair
  :ensure t
  :init
  (add-hook 'c-mode-common-hook #'(lambda () (autopair-mode)))
  (add-hook 'python-mode-hook #'(lambda () (autopair-mode))))

(provide 'init-autopair)
