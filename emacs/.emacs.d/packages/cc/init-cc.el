;; (c-set-offset 'access-label -1)

;; Flycheck C++11
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))
(setq irony-additional-clang-options '("-std=c++11"))

;; Code Style

(use-package google-c-style
  :ensure t)

(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
(add-hook 'c++-mode-common-hook 'google-set-c-style)
(add-hook 'c++-mode-common-hook 'google-make-newline-indent)

(defun inside-class-enum-p (pos)
  "Checks if POS is within the braces of a C++ \"enum class\"."
  (ignore-errors
    (save-excursion
      (goto-char pos)
      (up-list -1)
      (backward-sexp 1)
      (looking-back "enum[ \t]+class[ \t]+[^}]+"))))
(defun align-enum-class (langelem)
  (if (inside-class-enum-p (c-langelem-pos langelem))
      0
    (c-lineup-topmost-intro-cont langelem)))
(defun align-enum-class-closing-brace (langelem)
  (if (inside-class-enum-p (c-langelem-pos langelem))
      '-
    '*))

(defun my-c-mode ()
  "Setup `c++-mode' to better handle \"class enum\"."
  (setq tab-width 4 indent-tabs-mode nil)
  (setq c-basic-offset 4)
  (add-to-list 'c-offsets-alist '(topmost-intro-cont . align-enum-class))
  (add-to-list 'c-offsets-alist
               '(statement-cont . align-enum-class-closing-brace))
  (c-set-offset 'arglist-close '(c-lineup-arglist-operators 0))
  (c-set-offset 'arglist-intro 'c-basic-offset)
  (c-set-offset 'arglist-cont-nonempty '(add c-lineup-whitesmith-in-block
                                             c-indent-multi-line-block)))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-hook 'c++-mode-hook 'my-c-mode)
(add-hook 'c-mode-hook 'my-c-mode)

(provide 'init-cc)
