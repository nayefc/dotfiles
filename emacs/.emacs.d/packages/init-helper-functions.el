(defun get-relative-file-name ()
  "Retrieves the file name relative to the parent git project."
  (interactive)
  (let ((project-root
	 (f-full
	  (locate-dominating-file default-directory ".git"))))
    (if project-root
	(s-chop-prefix project-root buffer-file-name))))

(defun get-gihub-url ()
  "Return the Github url for the current line."
  (defvar github-url)
  (setq github-url
   (s-concat
    "https://github.com/USER/REPO/blob/master/"
    (get-relative-file-name)
    "#L"
    (number-to-string (line-number-at-pos)))))

(defun copy-repo-url ()
  "Put repo URL for the line at point in kill ring."
  (interactive)
  (kill-new (get-github-url))
  (message "Copied: %s" (get-github-url)))
(bind-key "C-x a u" 'copy-github-url)

(provide 'init-helper-functions)
