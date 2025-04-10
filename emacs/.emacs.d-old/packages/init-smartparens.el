(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :bind (("C-c h" . hydra-smartparens/body)
         ("M-]" . sp-unwrap-sexp)
         :map smartparens-strict-mode-map
         ;; A fill paragraph in strict mode
         ("M-q" . sp-indent-defun))
  :init
  ;; Hydra for Smartparens
  (defhydra hydra-smartparens (:hint nil)
    "
Sexps (quit with _q_)
^Nav^                                        ^Kill^                      ^Wrap^
^---^----------^---^-------------------------^---^---------^---^---------^---^--------------------
_l_: → char    _u_: ← word   _m_: ← indent   _e_: ← word   _c_: line     _(_: wrap with ( )
_j_: ← char    _o_: → word   _n_: new line   _r_: → word   _v_: sexp     _{_: wrap with { }
_i_: ↑ line    _a_: ← line                 _d_: ← char   _w_: copy     _'_: wrap with ' '
_k_: ↓ line    _s_: → line                 _f_: → char               _\"_: wrap with \" \""
    ("q" nil)

    ;; Wrapping
    ("(" (lambda (_) (interactive "P") (sp-wrap-with-pair "(")))
    ("{" (lambda (_) (interactive "P") (sp-wrap-with-pair "{")))
    ("'" (lambda (_) (interactive "P") (sp-wrap-with-pair "'")))
    ("\"" (lambda (_) (interactive "P") (sp-wrap-with-pair "\"")))

    ;; Nav:
    ("j" backward-char)
    ("l" forward-char)
    ("i" previous-line)
    ("k" next-line)
    ("o" forward-word)
    ("u" backward-word)
    ("n" electric-newline-and-maybe-indent)
    ("a" move-beginning-of-line)
    ("s" move-end-of-line)
    ("m" back-to-indentation)

    ;; Kill/Copy
    ("e" sp-backward-kill-word)
    ("r" sp-kill-word)
    ("d" sp-backward-delete-char)
    ("f" sp-delete-char)
    ("c" sp-kill-hybrid-sexp)
    ("v" sp-kill-sexp)
    ("w" sp-copy-sexp))

  ;; (smartparens-global-mode)
  ;; (show-smartparens-global-mode)
  (dolist (hook '(inferior-emacs-lisp-mode-hook
                  emacs-lisp-mode-hook))
    (add-hook hook #'smartparens-strict-mode))
  (add-hook 'python-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'c-mode-common-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)
  :config
  (require 'smartparens-config)

  (setq sp-autoskip-closing-pair 'always
        ;; Don't kill entire symbol on C-k
        sp-hybrid-kill-entire-symbol nil)

  ;; C++ block comment management
  (sp-local-pair 'c++-mode "/*" "*/" :post-handlers '((" | " "SPC")
                                                      ("* ||\n[i]" "RET")))
  (sp-local-pair 'c++-mode "{" nil :post-handlers '(("||\n[i]" "RET")))

  (setq sp-cancel-autoskip-on-backward-movement nil)

  ;; Temporary: https://github.com/Fuco1/smartparens/issues/963#issuecomment-488151756
  (dolist (fun '(c-electric-paren c-electric-brace))
    (add-to-list 'sp--special-self-insert-commands fun)))

(use-package hydra-smartparens
  :disabled t
  :after smartparens
  :config (hydra-smartparens-bind-keys))

(provide 'init-smartparens)
