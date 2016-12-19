(defun get-relative-file-name ()
  "Retrieves the file name relative to the parent git project."
  (interactive)
  (let ((project-root
	 (f-full
	  (locate-dominating-file default-directory ".git"))))
    (if project-root
	(s-chop-prefix project-root buffer-file-name))))

(defun get-repo-url ()
  "Return the repo url for the current line."
  (defvar repo-url)
  (setq repo-url
   (s-concat
    "https://phabricator.hudson-trading.com/diffusion/OPS/browse/master/"
    (get-relative-file-name)
    ";master$"
    (number-to-string (line-number-at-pos)))))

(defun copy-repo-url ()
  "Put repo URL for the line at point in kill ring."
  (interactive)
  (kill-new (get-repo-url))
  (message "Copied: %s" (get-repo-url)))
(bind-key "C-x a u" 'copy-repo-url)

(provide 'init-helper-functions)
