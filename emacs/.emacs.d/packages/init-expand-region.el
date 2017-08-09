(use-package expand-region
  :ensure t
  :bind (("C-x l" . er/mark-symbol))
  :init
  (require 'expand-region))

(defhydra hydra-python-expand-region (:hint nil)
    "
Python Expand Region (with with _q_)
^Regions^              ^Lines^              ^Symbols^
^----------------------^--------------------^----------^---------------
_._: expand region     _(_: inside pair     _y_: symbol
_-_: contract region   _)_: outside pair    _w_: word
_k_: kill              _s_: inside string   _t_: statement
_b_: block             _S_: outside string
_B_: outer block
_d_: block & decorator"
    ("q" nil)
    ("." er/expand-region)
    ("-" er/contract-region)
    ("y" er/mark-symbol)
    ("w" er/mark-word)
    ("t" er/mark-python-statement)
    ("(" er/mark-inside-pairs)
    (")" er/mark-outside-pairs)
    ("s" er/mark-inside-python-string)
    ("S" er/mark-outside-python-string)
    ("b" er/mark-python-block)
    ("B" er/mark-outer-python-block)
    ("d" er/mark-python-block-and-decorator)
    ("k" kill-region))

(add-hook 'python-mode-hook
          (lambda () (define-key python-mode-map (kbd "C-c m")
                       'hydra-python-expand-region/body)))

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
    ("f" c-mark-function)
    ("v" er/c-mark-vector-access)
    ;; ("b" er/c-mark-statement-block))
    )

(add-hook 'c++-mode-hook
          (lambda () (define-key c++-mode-map (kbd "C-c m")
                       'hydra-cc-expand-region/body)))
(add-hook 'c-mode-hook
          (lambda () (define-key c-mode-map (kbd "C-c m")
                       'hydra-cc-expand-region/body)))

(provide 'init-expand-region)
