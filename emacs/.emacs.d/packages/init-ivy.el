(use-package ivy
  :ensure t
  :diminish ivy-mode
  :bind (("M-x" . counsel-M-x)
  	 ("C-x C-f" . counsel-find-file)
  	 ("C-c g" . counsel-projectile-ag)
  	 ("C-M-m" . counsel-jedi))
  :config
  (ivy-mode 1)
  (setq ivy-count-format "")
  (setq ivy-display-style 'fancy)
  (setq ivy-re-builders-alist
	'((t . ivy--regex-ignore-order)))
  ;; no default regexp
  (setq ivy-initial-inputs-alist nil)
  (custom-set-faces
   '(ivy-modified-buffer ((t (:foreground "#ff7777"))))
   '(ivy-current-match ((t (:background "#436060"))))))

(use-package swiper
  :ensure t
  :diminish swiper
  :bind ("C-s" . swiper)
  :config
  (custom-set-faces
 '(swiper-match-face-1 ((t (:background "#d33682" :foreground "#002b36" :weight bold))))
 '(swiper-match-face-2 ((t (:background "#d33682" :foreground "#002b36" :weight bold))))
 '(swiper-match-face-3 ((t (:background "#d33682" :foreground "#002b36" :weight bold))))
 '(swiper-match-face-4 ((t (:background "#d33682" :foreground "#002b36" :weight bold))))))

;; See http://oremacs.com/2016/01/06/ivy-flx/ for fuzzy matching
;; (use-package flx
;;   :ensure t)

(provide 'init-ivy)
