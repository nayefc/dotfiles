;;; package --- Summary
;;; Commentary:
;;; Code:

(use-package highlight-indentation
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :bind (("C-c i" . highlight-indentation-mode))
  :config
  (set-face-font 'highlight-indentation-face "Arial")
  (set-face-background 'highlight-indentation-face "#E0E0E0")
  ;; (set-face-attribute 'highlight-indentation-face nil :height 52)
  (defun indentation-toggle-fold ()
    "Toggle fold all lines larger than indentation on current line"
    (interactive)
    (let ((col 1))
      (save-excursion
	(back-to-indentation)
	(setq col (+ 1 (current-column)))
	(set-selective-display
	 (if selective-display nil (or col 1))))))
  (eval-after-load 'highlight-indentation
    (bind-key "C-c u" 'indentation-toggle-fold python-mode-map)))

(provide 'init-highlight-indentation)
;;; init-highlight-indentation.el ends here
