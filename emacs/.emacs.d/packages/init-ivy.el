(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode 1)
  (setq ivy-count-format "")
  (custom-set-faces
   '(ivy-modified-buffer ((t (:foreground "#ff7777"))))))

;; See http://oremacs.com/2016/01/06/ivy-flx/ for fuzzy matching
;; (use-package flx
;;   :ensure t)

(provide 'init-ivy)
