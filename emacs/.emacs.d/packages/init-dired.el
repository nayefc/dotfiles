;; Add dired-x mode to dired
(add-hook 'dired-load-hook (lambda () (load "dired-x")))

(put 'dired-find-alternate-file 'disabled nil)

(setq-default dired-omit-files-p t)

(setq dired-omit-files "^\\.[^.]\\|\\.pyc$")

(provide 'init-dired)
