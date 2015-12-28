(defun hs-enable-and-toggle ()
  "Enable hs and toggle block."
  (interactive)
  (hs-minor-mode 1)
  (hs-toggle-hiding))
(bind-key "C-x ," 'hs-enable-and-toggle)

(defun get-relative-file-name ()
  "Retrieves the file name relative to the parent git project."
  (interactive)
  (let ((project-root
	 (f-full
	  (locate-dominating-file default-directory ".git"))))
    (if project-root
	(s-chop-prefix project-root buffer-file-name))))

(defun get-github-url ()
  "Return the Github url for the current line."
  (defvar github-url)
  (setq github-url
   (s-concat
    "https://github.com/percolate/hotlanta/blob/master/"
    (get-relative-file-name)
    "#L"
    (number-to-string (line-number-at-pos)))))

(defun copy-hotlanta-github-url ()
  "Put hotlanta URL for the line at point in kill ring."
  (interactive)
  (kill-new (get-github-url))
  (message "Copied: %s" (get-github-url)))
(bind-key "C-x a u" 'copy-hotlanta-github-url)

(provide 'init-helper-functions)
