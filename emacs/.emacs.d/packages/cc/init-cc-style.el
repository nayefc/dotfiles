(c-set-offset 'access-label -1)

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
(add-hook 'c-mode-common-hook 'my-c-mode)

;; Set google-c-style after my-c-mode to have the above c-basic-offset 4 take effect.
(use-package google-c-style
  :ensure t
  :mode (("\\.cc\\'" . c++-mode)
	 ("\\.cpp\\'" . c++-mode)
	 ("\\.h\\'" . c++-mode)
	 ("\\.c\\'" . c-mode))
  :config
  (bind-keys :map c-mode-map
	     ("C-c ." . nil)
	     ("C-c ," . nil)
	     ("C-c /" . nil)
	     ("C-c /" . mc/mark-all-like-this)))

(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

(use-package modern-cpp-font-lock
  :ensure t)
(add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)

(provide 'init-cc-style)
