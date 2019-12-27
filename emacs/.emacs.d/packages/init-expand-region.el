(use-package expand-region
  :ensure t
  :bind (("C-x l" . er/mark-symbol))
  :init
  (require 'expand-region))

(defhydra hydra-python-expand-region (:hint nil)
    "
C/C++ Expand Region (with with _q_)
^Symbols^            ^Lines^
^--------------------^---------------------
_._: expand region   _(_: inside pair
_m_: symbol          _)_: outside pair
_n_: full name       _s_: inside quotes
_t_: statement       _S_: outside quotes
_f_: mark function   _v_: vector access"
    ("q" nil)
    ("." er/expand-region)
    ("m" er/mark-symbol)
    ;; ("w" er/mark-word)
    ("t" er/c-mark-statement)
    ("n" er/c-mark-fully-qualified-name)
    ("(" er/mark-inside-pairs)
    (")" er/mark-outside-pairs)
    ("s" er/mark-inside-quotes)
    ("S" er/mark-outside-quotes)
    ("f" c-mark-function)
    ("v" er/c-mark-vector-access)
    ;; ("b" er/c-mark-statement-block))
    )

(add-hook 'python-mode-hook
          (lambda () (define-key python-mode-map (kbd "C-c m")
                       'hydra-python-expand-region/body)))

(defhydra hydra-cc-expand-region (:hint nil)
    "
C/C++ Expand Region (with with _q_)
^Symbols^            ^Lines^
^--------------------^---------------------
_._: expand region   _(_: inside pair
_s_: symbol          _)_: outside pair
_w_: word            _s_: inside quotes
_t_: statement       _S_: outside quotes
_n_: full name       _v_: vector access
                   _f_: mark function"
    ("q" nil)
    ("." er/expand-region)
    ("s" er/mark-symbol)
    ("w" er/mark-word)
    ("t" er/c-mark-statement)
    ("n" er/c-mark-fully-qualified-name)
    ("(" er/mark-inside-pairs)
    (")" er/mark-outside-pairs)
    ("s" er/mark-inside-quotes)
    ("S" er/mark-outside-quotes)
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
