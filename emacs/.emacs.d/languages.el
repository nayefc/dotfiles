;;; languages.el --- Misc configuration

;;; Commentary:

;;; Code:

;; Automatically indent on new line
(defun newline-indents ()
  "Bind Return to `newline-and-indent' in the local keymap."
  (local-set-key "\C-m" 'newline-and-indent))

;; Tell Emacs to use the function above in certain editing modes.
(add-hook 'lisp-mode-hook             (function newline-indents))
(add-hook 'emacs-lisp-mode-hook       (function newline-indents))
(add-hook 'lisp-interaction-mode-hook (function newline-indents))
(add-hook 'scheme-mode-hook           (function newline-indents))
(add-hook 'c-mode-hook                (function newline-indents))
(add-hook 'c++-mode-hook              (function newline-indents))
(add-hook 'java-mode-hook             (function newline-indents))
(add-hook 'python-mode-hook           (function newline-indents))

;; Set default indent to 4
(setq-default c-basic-offset 2)

;; Indent JavaScript to 2
(add-hook 'js-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq js-indent-level 2)))

;; Indent automatically in JavaScript
(add-hook 'js-mode-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))

(provide 'languages)
;;; languages.el ends here
