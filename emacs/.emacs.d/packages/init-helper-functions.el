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
    (s-concat
     "https://phabricator.hudson-trading.com/diffusion/"
     (car
      (s-split "/"
               (car (cdr
                     (s-split
                      "diffusion/"
                      (s-trim
                       (shell-command-to-string
                        "git config --get \"remote.origin.url\"")))))))
     "/browse/master/"
     )
    (get-relative-file-name)
    ";"
    ;; (car (s-split "\n" (s-trim
    ;;                          (shell-command-to-string "git rev-parse master HEAD"))))
    "master$"
    (number-to-string (line-number-at-pos)))))

(defun copy-repo-url ()
  "Put repo URL for the line at point in kill ring."
  (interactive)
  (kill-new (get-repo-url))
  (message "Copied: %s" (get-repo-url)))
(bind-key "C-x a u" 'copy-repo-url)

(provide 'init-helper-functions)
