;; Set GUI Emacs theme

;; Set default window size
(add-to-list 'default-frame-alist '(height . 30))
(add-to-list 'default-frame-alist '(width . 90))

;; Disable toolbar
(tool-bar-mode -1)

;; Disable scroll bar
(if (display-graphic-p) (scroll-bar-mode -1))

;; Highlight current line
(global-hl-line-mode +1)

;; (use-package solarized-theme
;;   :ensure t
;;   :if (display-graphic-p)
;;   :init
;;   (setq solarized-use-variable-pitch nil)
;;   (setq solarized-scale-headlines nil)

;;   ;; (load-theme 'solarized-dark t)

;;   ;; make the fringe stand out from the background
;;   (setq solarized-distinct-fringe-background t)

;;   ;; make the modeline high contrast
;;   (setq solarized-high-contrast-mode-line t)

;;   ;; Use less bolding
;;   (setq solarized-use-less-bold t)

;;   ;; Use more italics
;;   (setq solarized-use-more-italic t)

;;   ;; Use less colors for indicators such as git:gutter, flycheck and similar.
;;   (setq solarized-emphasize-indicators nil)

;;   (setq x-underline-at-descent-line t))

;; ;; zeno-theme
;; (use-package zeno-theme
;;   :ensure t
;;   :init)

(use-package nord-theme
  :ensure t
  :config
  (setq nord-region-highlight "snowstorm"))

;; Toggle between light and dark themes
(defvar *my-dark-theme* 'solarized-dark)
(defvar *my-light-theme* 'solarized-light)
(defvar *my-zeno-theme* 'zeno-theme)
(defvar *my-current-theme* *my-dark-theme*)

;; disable other themes before loading new one
(defadvice load-theme (before theme-dont-propagate activate)
  "Disable theme before loading new one."
  (mapc #'disable-theme custom-enabled-themes))

(defun next-theme (theme)
  (disable-theme *my-current-theme*)
  (load-theme theme t)
  ;; (if (eq theme 'default)
  ;;     (disable-theme *haba-current-theme*)
  ;;   (progn
  ;;     (load-theme theme t)))
  (setq *my-current-theme* theme))

(defun toggle-theme ()
  (interactive)
  (cond ((eq *my-current-theme* *my-dark-theme*) (next-theme *my-light-theme*))
        ((eq *my-current-theme* *my-light-theme*) (next-theme *my-zeno-theme*))
        ((eq *my-current-theme* *my-zeno-theme*) (next-theme *my-dark-theme*))))

;; Load theme
;; (load-theme 'solarized-dark t)
(load-theme 'nord t)

;; Make title bar match macOS theme
(use-package ns-auto-titlebar
  :ensure t
  :diminish
  :init
  (ns-auto-titlebar-mode))

(defun finder ()
  "Opens file directory in Finder."
  (interactive)
  (let ((file (buffer-file-name)))
    (if file
        (shell-command
         (format "%s %s" (executable-find "open") (file-name-directory file)))
      (error "Buffer is not attached to any file"))))

(provide 'init-gui)
