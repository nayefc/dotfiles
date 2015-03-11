;;; osx.el --- OS X configuration
;;; Commentary:

;;; Code:

(require 'use-package)

(use-package solarized-theme
  :ensure t
  :if (featurep 'ns-win)  ; check if we're on OS X
  :init
  (progn
    ;; Disable scroll bar
    (scroll-bar-mode -1)

    ;; Load theme
    (load-theme 'solarized-dark t)

    ;; make the fringe stand out from the background
    (setq solarized-distinct-fringe-background t)

    ;; make the modeline high contrast
    (setq solarized-high-contrast-mode-line t)

    ;; Use less bolding
    (setq solarized-use-less-bold t)

    ;; Use more italics
    (setq solarized-use-more-italic t)

    ;; Use less colors for indicators such as git:gutter, flycheck and similar.
    (setq solarized-emphasize-indicators nil)

    (setq x-underline-at-descent-line t)

    (custom-set-variables
     ;; custom-set-variables was added by Custom.
     ;; If you edit it by hand, you could mess it up, so be careful.
     ;; Your init file should contain only one such instance.
     ;; If there is more than one, they won't work right.
     '(custom-safe-themes (quote ("e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e"
				  "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879"
				  "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4"
				  default))))
    (custom-set-faces
     ;; custom-set-faces was added by Custom.
     ;; If you edit it by hand, you could mess it up, so be careful.
     ;; Your init file should contain only one such instance.
     ;; If there is more than one, they won't work right.
					; '(default ((t (:height 150 :width normal :family "Terminus"))))
     '(default ((t (:height 150 :width normal :family "Monaco")))))))

;; Bring OS X Emacs in line with shell setup
(use-package exec-path-from-shell
  :init (exec-path-from-shell-initialize))

(defun finder ()
  "Opens file directory in Finder."
  (interactive)
  (let ((file (buffer-file-name)))
    (if file
        (shell-command
         (format "%s %s" (executable-find "open") (file-name-directory file)))
      (error "Buffer is not attached to any file."))))

(provide 'osx)
;;; osx.el ends here
