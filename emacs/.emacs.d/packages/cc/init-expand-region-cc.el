(use-package cc-expand-region
  :ensure expand-region
  :init
  (defhydra hydra-cc-expand-region (:hint nil)
    "
C++ Expand Region (with with _q_)
^Symbols^            ^Lines^
^--------------------^---------------------
_._: expand region   _(_: inside pair
_s_: symbol          _)_: outside pair
_w_: word            _q_: inside quotes
_t_: statement       _Q_: outside quotes
_n_: full name       _v_: vector access"
    ("q" nil)
    ("." er/expand-region)
    ("s" er/mark-symbol)
    ("w" er/mark-word)
    ("t" er/c-mark-statement)
    ("n" er/c-mark-fully-qualified-name)
    ("(" er/mark-inside-pairs)
    (")" er/mark-outside-pairs)
    ("q" er/mark-inside-quotes)
    ("Q" er/mark-outside-quotes)
    ;; ("f" er/c-mark-function-call)
    ("v" er/c-mark-vector-access)
    ;; ("b" er/c-mark-statement-block))
    :config (hydra-cc-expand-region-bind-keys)))

(add-hook 'c++-mode-hook
	  (lambda () (define-key c++-mode-map (kbd "C-c m")
		       'hydra-cc-expand-region/body)))

(provide 'init-expand-region-cc)
