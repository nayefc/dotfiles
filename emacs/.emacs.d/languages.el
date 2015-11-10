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

;; Set python indent to 4
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq python-indent-offset 4)))

;; Insert ipdb in python shortcut
(defun python-add-breakpoint ()
  "Add python breakpoint."
  (interactive)
  (back-to-indentation)
  (insert "import ipdb; ipdb.set_trace()")
  (newline-and-indent))
(define-key python-mode-map (kbd "C-c t") 'python-add-breakpoint)

(defun goto-python-class (classname)
  "Search for a python class CLASSNAME in the current file."
  (interactive "sClass name: ")
  (unless (search-forward (concat "class " classname) nil t nil)
    (search-backward (concat "class " classname "("))))
;;(bind-key "C-x a s" 'goto-python-class)
(define-key python-mode-map (kbd "C-x a c") 'goto-python-class)

(defun goto-python-function (funcname)
  "Search for a python function FUNCNAME in the current file."
  (interactive "sFunction name: ")
  (unless (search-forward (concat "def " funcname) nil t nil)
    (search-backward (concat "def " funcname "("))))
(define-key python-mode-map (kbd "C-x a f") 'goto-python-function)

(defun copy-function-name ()
  "Put name of function at point to \"kill-ring\"."
  (interactive)
  (kill-new (which-function))
  (message "Copied %s" (which-function)))
(bind-key "C-x a i f" 'copy-function-name)

(defun copy-function-file-and-name ()
  "Put name file and name of function at point to \"kill-ring\"."
  (interactive)
  (defvar function-file-and-name)
  (setq function-file-and-name
    (s-concat
     (s-replace-all '(("/" . ".") (".py" . "")) (get-relative-file-name))
     ":"
     (which-function)))
  (kill-new function-file-and-name)
  (message "Copied: %s" function-file-and-name))
(bind-key "C-x c" 'copy-function-file-and-name)

;; Indent JavaScript to 2
(add-hook 'js-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq js-indent-level 2)))

;; Indent automatically in JavaScript
(add-hook 'js-mode-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))


(provide 'languages)
;;; languages.el ends here
