;; This follows the 90ish rule
;; See https://www.youtube.com/watch?v=wf-BqAjZb8M

;; Highlight lines over 100 characters
(setq-default
 whitespace-line-column 100
 whitespace-style       '(face lines-tail))
(add-hook 'prog-mode-hook #'whitespace-mode)

;; Set line indicator at 90
(use-package fci-mode
  :ensure fill-column-indicator
  :defer t
  :defines fci-column-indicator fci-handle-truncate-lines fci-rule-column
  :init
  (setq fci-rule-column 90)
  (setq fci-column-indicator 90)

  (defun auto-fci-mode (&optional unused)
    (if (> (window-width) fci-rule-column)
        (if (and
           (not (string-match "^\*.*\*$" (buffer-name)))
           (not (eq major-mode 'dired-mode))
           (not (eq major-mode 'neotree-mode)))
            (fci-mode 1)
          (fci-mode 0))))

  (add-hook 'after-change-major-mode-hook 'auto-fci-mode)
  (add-hook 'window-configuration-change-hook 'auto-fci-mode))

;; Disable fci when autocomplete is on the line, as fci breaks autocomplete.
(defun sanityinc/fci-enabled-p ()
  "From http://emacs.stackexchange.com/questions/147/how-can-i-get-a-ruler-at-column-80."
  (symbol-value 'fci-mode))
(defvar sanityinc/fci-mode-suppressed nil)
(make-variable-buffer-local 'sanityinc/fci-mode-suppressed)
(defadvice popup-create (before suppress-fci-mode activate)
  "Suspend fci-mode while popups are visible."
  (let ((fci-enabled (sanityinc/fci-enabled-p)))
    (when fci-enabled
      (setq sanityinc/fci-mode-suppressed fci-enabled)
      (turn-off-fci-mode))))
(defadvice popup-delete (after restore-fci-mode activate)
  "Restore fci-mode when all popups have closed."
  (when (and sanityinc/fci-mode-suppressed
             (null popup-instances))
    (setq sanityinc/fci-mode-suppressed nil)
          (turn-on-fci-mode)))

(provide 'init-fci-mode)
