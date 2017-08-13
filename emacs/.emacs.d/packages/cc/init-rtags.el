;;; package --- Summary
;;; Commentary:
;;; I use rtags primarily for navigation and jumping around C/C++.
;;; Code:

;; TODO: auto index project in rtags -- see cmake-ide

(use-package rtags
  :ensure t
  :mode (("\\.cc\\'" . c++-mode)
         ("\\.cpp\\'" . c++-mode)
         ("\\.h\\'" . c++-mode)
         ("\\.c\\'" . c-mode))
  :bind (:map c-mode-base-map
	 ("C-c k" . rtags-find-symbol-at-point)
	 ("C-c j" . rtags-location-stack-back)
	 ("C-c ;" . rtags-symbol-type))
  :init
  (cmake-ide-setup)
  (setq cmake-ide-flags-c++ (append '("-std=c++11")))
  (rtags-enable-standard-keybindings)
  (setq rtags-autostart-diagnostics t))

(provide 'init-rtags)
