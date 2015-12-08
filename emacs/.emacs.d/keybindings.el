;;; keybindings.el --- Misc configuration
;;; Commentary:

;;; Code:

;; buffer-move
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; Default search to regexp search
(global-set-key (kbd "C-s") 'isearch-forward-regexp)

;; Scroll other window
(bind-key "C-c n" 'scroll-other-window)
(bind-key "C-c b" 'scroll-other-window-down)

;; Kill current line
(defun smart-kill-whole-line (&optional arg)
  "A wrapper around 'kill-whole-line' that respects indentation with ARG lines to kill."
  (interactive "P")
  (kill-whole-line arg)
  (back-to-indentation))
(global-set-key (kbd "C-c d") 'smart-kill-whole-line)

;; Copy line
(defun copy-line ()
  "Copy the current line."
  (interactive)
  (save-excursion
    (back-to-indentation)
    (kill-ring-save
     (point)
     (line-end-position)))
  (message "1 line copied"))
(global-set-key (kbd "C-c y") 'copy-line)

;; Duplicate a line
(defun duplicate-line ()
  "Duplicate current line to the line below and preserve indentation."
  (interactive)
  (beginning-of-line)
  (push-mark)
  (end-of-line)
  (let ((str (buffer-substring (region-beginning) (region-end))))
    (insert
     (concat (if (= 0 (forward-line 1)) "" "\n") str "\n"))
    (forward-line -1)))
(global-set-key (kbd "C-c f") 'duplicate-line)

;; Mark whole line
(defun mark-line ()
  "Mark a line."
  (interactive)
  (back-to-indentation)
  (set-mark-command nil)
  (move-end-of-line nil)
  (message "Lined marked")
  (setq deactivate-mark nil))
(global-set-key (kbd "C-c l") 'mark-line)

;; Wrapper around simple.el open-line that handles indentation properly
(defun open-line-wrapper (&optional n)
  "Wrapper around simple.el \"open-line\" that handles indentation properly for N lines."
  (interactive "*p")
  (save-excursion
    (move-end-of-line nil)
    (if n
	(open-line n)
      (open-line 1))))
(bind-key "C-o" 'open-line-wrapper)

;; Minify JSON
(defun minify-json ()
  "Minify JSON removing newlines and whitespace."
  (interactive)
  (goto-char 1)
  (while (search-forward-regexp "\n" nil t)
    (replace-match "" t))
  (goto-char 1)
  (while (search-forward-regexp "\s-*" nil t)
    (replace-match "" t)))

(provide 'keybindings)
;;; keybindings.el ends here
