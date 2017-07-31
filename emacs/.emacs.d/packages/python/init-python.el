;;; package -- Summary

;;; Commentary:

(defun python-add-breakpoint ()
  "Add python ipdb breakpoint."
  (interactive)
  (back-to-indentation)
  (insert "import ipdb; ipdb.set_trace()")
  (newline-and-indent))

(add-hook 'python-mode-hook 'hs-minor-mode)
(defun hs-enable-and-toggle ()
  "Enable hs and toggle block."
  (interactive)
  (hs-toggle-hiding))

;; This will run when python mode is loaded
(use-package python
  :config
  (setq python-indent-offset 4)
  ;; Bind keys from previous defined functions
  (bind-keys :map python-mode-map
	     ("C-c t" . python-add-breakpoint)
	     ("C-x ," . hs-enable-and-toggle))
  )

;; Temporary for iPython to work
(setenv "IPY_TEST_SIMPLE_PROMPT" "1")
(when (executable-find "ipython")
  (setq python-shell-interpreter "ipython"))

;; Misc python functions

(defun goto-python-class (classname)
  "Search for a python class CLASSNAME in the current file."
  (interactive "sClass name: ")
  (unless (search-forward (concat "class " classname) nil t nil)
    (search-backward (concat "class " classname "("))))

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

(defun copy-function-name ()
  "Put name of function at point to \"kill-ring\"."
  (interactive)
  (kill-new (which-function))
  (message "Copied %s" (which-function)))
;; (bind-key "C-x a i f" 'copy-function-name python-mode-map)

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
;; (bind-key "C-x c" 'copy-function-file-and-name python-mode-map)

(provide 'init-python)
;;; init-python.el ends here
