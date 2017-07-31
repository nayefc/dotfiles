(use-package py-expand-region
  :ensure expand-region
  :init
  (defhydra hydra-python-expand-region (:hint nil)
    "
Python Expand Region (with with _q_)
^Symbols^            ^Lines^              ^Regions^
^--------------------^--------------------^----------^---------------
_._: expand region   _(_: inside pair     _b_: block
_s_: symbol          _)_: outside pair    _B_: outer block
_w_: word            _s_: inside string   _d_: block & decorator
_t_: statement       _S_: outside string"
    ("q" nil)
    ("." er/expand-region)
    ("s" er/mark-symbol)
    ("w" er/mark-word)
    ("t" er/mark-python-statement)
    ("(" er/mark-inside-pairs)
    (")" er/mark-outside-pairs)
    ("s" er/mark-inside-python-string)
    ("S" er/mark-outer-python-string)
    ("b" er/mark-python-block)
    ("B" er/mark-outer-python-block)
    ("d" er/mark-python-block-and-decorator))
  :config (hydra-python-expand-region-bind-keys))

(add-hook 'python-mode-hook
	  (lambda () (define-key python-mode-map (kbd "C-c m")
		       'hydra-python-expand-region/body)))


(provide 'init-expand-region-py)
