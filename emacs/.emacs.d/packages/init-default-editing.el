;; Default search to regexp search
(global-set-key (kbd "C-s") 'isearch-forward-regexp)

;; Scroll other window
(bind-key "C-c n" 'scroll-other-window)
(bind-key "C-c b" 'scroll-other-window-down)

;; Automatically indent on new line
(defun newline-indents ()
  "Bind Return to `newline-and-indent' in the local keymap."
  (local-set-key "\C-m" 'newline-and-indent))

;; Tell Emacs to use the function above in certain editing modes.
(add-hook 'lisp-mode-hook             (function newline-indents))
(add-hook 'emacs-lisp-mode-hook       (function newline-indents))
(add-hook 'lisp-interaction-mode-hook (function newline-indents))
(add-hook 'scheme-mode-hook           (function newline-indents))
(add-hook 'python-mode-hook           (function newline-indents))

;; Indent json by 2
(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))

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

(defun better-whitespace ()
  (interactive)
  (whitespace-mode -1)
  (let ((ws-small '(face lines-tail))
        (ws-big '(face tabs spaces trailing lines-tail space-before-tab
                       newline indentation empty space-after-tab space-mark
                       tab-mark newline-mark)))
    (if (eq whitespace-style ws-small)
        (setq whitespace-style ws-big)
      (setq whitespace-style ws-small)))
  (whitespace-mode 1))

(provide 'init-default-editing)
