(use-package pyenv-mode
  :ensure t
  :config
  (pyenv-mode))

(defun convert-python-dict-to-json ()
  "Convert a python unicode dict to valid JSON."
  (interactive)
  (goto-char 1)
  (while (search-forward-regexp "u'" nil t)
    (replace-match "\""))
  (goto-char 1)
  (while (search-forward-regexp "'" nil t)
    (replace-match "\""))
  (goto-char 1)
  (while (search-forward-regexp "None" nil t)
    (replace-match "null" t))
  (goto-char 1)
  (while (search-forward-regexp "True" nil t)
    (replace-match "true" t))
  (goto-char 1)
  (while (search-forward-regexp "False" nil t)
    (replace-match "false" t)))

;; Set python indent to 4
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq python-indent-offset 4)))

(defun python-add-breakpoint ()
  "Add python ipdb breakpoint."
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
(define-key python-mode-map (kbd "C-x a c") 'python-add-breakpoint)

(defun goto-python-function (funcname)
  "Search for a python function FUNCNAME in the current file."
  (interactive "sFunction name: ")
  (unless (search-forward (concat "def " funcname) nil t nil)
    (search-backward (concat "def " funcname "("))))
(bind-key "C-x a f" 'goto-python-function python-mode-map)

(defun copy-function-name ()
  "Put name of function at point to \"kill-ring\"."
  (interactive)
  (kill-new (which-function))
  (message "Copied %s" (which-function)))
(bind-key "C-x a i f" 'copy-function-name python-mode-map)

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
(bind-key "C-x c" 'copy-function-file-and-name python-mode-map)

(provide 'init-python)
