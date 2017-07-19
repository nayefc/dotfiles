;; (c-set-offset 'access-label -1)

;; Flycheck C++11
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))
(setq irony-additional-clang-options '("-std=c++11"))

;; Code Style

(use-package google-c-style
  :ensure t)

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
(defconst hrt-c-style
  '((c-tab-always-indent           . t)
    (c-comment-only-line-offset    . 0)
    (c-indent-comments-syntactically-p . t)
    (c-hanging-braces-alist        . ((class-open after)
                                      (inline-open nil)
                                      (inline-close after)
                                      (substatement-open after)
                                      (brace-list-open)))
    (c-hanging-colons-alist        . ((member-init-intro before)
                                      (inher-intro)
                                      (case-label after)
                                      (label after)
                                      (access-label after)))
    (c-cleanup-list                . (scope-operator
                                      empty-defun-braces
                                      defun-close-semi))
    (c-offsets-alist               . ((arglist-close . c-lineup-arglist)
                                      (access-label      . -2)
                                      (block-open        . -4)
                                      (case-label        . +)
                                      (inline-open       . ++)
                                      (knr-argdecl-intro . -)
                                      (label             . *)
                                      (substatement-open . 0)
                                      (innamespace . [0])
                                      ))
    (c-echo-syntactic-information-p . t)
    ) "HRT C Programming Style")

(defun hrt-c-mode ()
  "Setup `c++-mode' to better handle \"class enum\"."
  (c-add-style "hrt-c-style" hrt-c-style t)
  (setq tab-width 4 indent-tabs-mode nil)
  (add-to-list 'c-offsets-alist '(topmost-intro-cont . align-enum-class))
  (add-to-list 'c-offsets-alist
               '(statement-cont . align-enum-class-closing-brace))
  (c-set-offset 'arglist-close '(c-lineup-arglist-operators 0))
  (c-set-offset 'arglist-intro 'c-basic-offset)
  (c-set-offset 'arglist-cont-nonempty '(add c-lineup-whitesmith-in-block
                                             c-indent-multi-line-block)))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-hook 'c++-mode-hook 'hrt-c-mode)
(add-hook 'c-mode-hook 'hrt-c-mode)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;;(add-hook 'c++-mode-hook 'turn-on-smart-parens-strict-mode)
(add-hook 'c++-mode-hook 'smartparens-strict-mode)

(defun fix-brace-indentation ()
  (sp-with-modes '(malabar-mode c++-mode)
    (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET"))))
  (sp-local-pair 'c++-mode "/*" "*/" :post-handlers '((" | " "SPC")
						      ("* ||\n[i]" "RET"))))
(add-hook 'c++-mode-hook 'fix-brace-indentation)

(provide 'init-cc)
