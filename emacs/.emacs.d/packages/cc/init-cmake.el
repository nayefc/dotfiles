;;; package --- Summary
;;; Commentary:
;;; C/C++ IDE-ish features.
;;; Code:

(use-package cmake-ide
  :ensure t
  :mode (("\\.cc\\'" . c++-mode)
         ("\\.cpp\\'" . c++-mode)
         ("\\.h\\'" . c++-mode)
         ("\\.c\\'" . c-mode))
  :init
  (cmake-ide-setup)
  (setq cmake-ide-flags-c++ (append '("-std=c++17")))) ;; -fconcepts

(provide 'init-cmake)
