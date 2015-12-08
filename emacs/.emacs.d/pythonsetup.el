;;; pythonsetup.el --- Python configuration

;;; Commentary:

;;; Code:

(use-package pyenv-mode)

(defun jedi:goto-definition-same-frame ()
  "Jedi goto-definition wrapper to go to definition directly."
  (interactive)
  (jedi:goto-definition nil `definition))

(defun jedi:goto-definition-new-frame ()
  "Jedi goto-definition wrapper in a new, nexts frame."
  (interactive)
  (jedi:goto-definition 1 `definition))

(use-package jedi
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :commands jedi:setup
  :bind (("C-c k" . jedi:goto-definition-same-frame)
	 ("C-c ;" . jedi:goto-definition-new-frame)
	 ("C-c '" . jedi:goto-definition)
	 ("C-c j" . jedi:goto-definition-pop-marker)
	 ("C-c ?" . jedi:show-doc)
	 ("C-c \\" . helm-jedi-related-names))
  :init
  (progn
    (setq jedi:server-command '("/Users/nayefcopty/dotfiles/emacs/emacs-jedi/jediepcserver.py"))
    (add-hook 'python-mode-hook 'jedi:setup)
    (setq jedi:complete-on-dot t)
    (setq jedi:tooltip-method '(pos-tip)))
  :config
  (progn
    (bind-keys :map jedi-mode-map
	       ("C-c ." . nil)
	       ("C-c ," . nil)
	       ("C-c /" . nil))))

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
(bind-key "C-c t" 'python-add-breakpoint python-mode-map)

(defun goto-python-class (classname)
  "Search for a python class CLASSNAME in the current file."
  (interactive "sClass name: ")
  (unless (search-forward (concat "class " classname) nil t nil)
    (search-backward (concat "class " classname "("))))
(bind-key "C-x a c" 'goto-python-class python-mode-map)

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

(provide 'pythonsetup)
;;; pythonsetup.el ends here
