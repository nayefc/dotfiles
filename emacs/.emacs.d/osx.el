;;; osx.el --- OS X configuration
;;; Commentary:

;;; Code:

(require 'use-package)

; Set GUI Emacs theme
(use-package solarized-theme
  :ensure t
  :if (display-graphic-p)
  :init
  (progn
    ;; Set default window size
    (add-to-list 'default-frame-alist '(height . 30))
    (add-to-list 'default-frame-alist '(width . 90))

    ;; Disable toolbar
    (tool-bar-mode -1)

    ;; Disable scroll bar
    (scroll-bar-mode -1)

    ;; Load theme
    (load-theme 'solarized-dark t)

    ;; make the fringe stand out from the background
    (setq solarized-distinct-fringe-background t)

    ;; make the modeline high contrast
    (setq solarized-high-contrast-mode-line t)

    ;; Use less bolding
    (setq solarized-use-less-bold t)

    ;; Use more italics
    (setq solarized-use-more-italic t)

    ;; Use less colors for indicators such as git:gutter, flycheck and similar.
    (setq solarized-emphasize-indicators nil)

    (setq x-underline-at-descent-line t)

    ;; Highlight current line
    (global-hl-line-mode +1)

    ;; Set the font size according to number of displays.
    (if (> (display-screens) 1)
	(set-frame-font "Inconsolata-g-13")
      (set-frame-font "Inconsolata-g-11"))

    ;; Scale font size and adjust fci column ruler.
    (define-globalized-minor-mode global-text-scale-mode text-scale-mode
      (lambda ()
	(text-scale-mode 1)))

    (defun global-text-scale-adjust (inc)
      "Adjust text cale by INC."
      (interactive)
      (text-scale-set 1)
      (kill-local-variable 'text-scale-mode-amount)
      (setq-default text-scale-mode-amount (+ text-scale-mode-amount inc))
      (global-text-scale-mode 1))

    (defun reset-font-size ()
      "Reset font size on all buffers to default."
      (interactive)
      (fci-mode 0)
      (global-text-scale-adjust (- text-scale-mode-amount))
      (global-text-scale-mode -1)
      (setq-default fci-rule-column 80)
      (fci-mode 1))
    (bind-key "C-c 0" 'reset-font-size)

    (defun increase-font-size ()
      "Increase font size by 1."
      (interactive)
      (fci-mode 0)
      (global-text-scale-adjust 1))
    (bind-key "C-c +" 'increase-font-size)

    (defun decrease-font-size ()
      "Decrease font size by 1."
      (interactive)
      (fci-mode 0)
      (global-text-scale-adjust -1))
    (bind-key "C-c -" 'decrease-font-size)))


(defun finder ()
  "Opens file directory in Finder."
  (interactive)
  (let ((file (buffer-file-name)))
    (if file
	(shell-command
	 (format "%s %s" (executable-find "open") (file-name-directory file)))
      (error "Buffer is not attached to any file"))))


;; Bring OS X Emacs in line with shell setup
;; This allows Emacs to use the same PATH as the the one used by the shell,
;; to access packages in PATH.
(use-package exec-path-from-shell
  :ensure t
  :init (exec-path-from-shell-initialize))


(provide 'osx)
;;; osx.el ends here
