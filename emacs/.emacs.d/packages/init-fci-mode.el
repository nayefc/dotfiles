(use-package fci-mode
  :ensure fill-column-indicator
  :defer t
  :defines fci-column-indicator fci-handle-truncate-lines fci-rule-column
  :init
  (add-hook 'c-mode-hook 'fci-mode)
  (add-hook 'python-mode-hook 'fci-mode)
  (add-hook 'ruby-mode-hook 'fci-mode)
  (add-hook 'emacs-lisp-mode-hook 'fci-mode)
  (setq fci-rule-column 80)
  (setq fci-column-indicator 80)
  (setq fci-handle-truncate-lines nil)
  (defun auto-fci-mode (&optional unused)
    (if (> (window-width) fci-rule-column)
	(fci-mode 1)
      (fci-mode 0)))
  (add-hook 'after-change-major-mode-hook 'auto-fci-mode)
  (add-hook 'window-configuration-change-hook 'auto-fci-mode)
  :config
  (defun auto-fci-mode (&optional unused)
    (if (> (window-width) fci-rule-column)
	(fci-mode 1)
      (fci-mode 0))))

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
