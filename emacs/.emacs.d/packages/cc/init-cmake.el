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
  ;; -fconcepts
  (setq cmake-ide-flags-c++ (append '("-std=c++17 -Wno-pragma-once-outside-header -I/usr/local/include/c++/7.4.0/"))))

(defun fix-clang-args (orig-fun &rest args)
 (let ((clang-args flycheck-clang-args))
  (apply orig-fun args)
  (setq flycheck-clang-args (append flycheck-clang-args clang-args))))
(advice-add 'cmake-ide--set-flags-for-file :around #'fix-clang-args)

(provide 'init-cmake)
