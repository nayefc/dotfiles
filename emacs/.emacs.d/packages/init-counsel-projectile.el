;;; package -- Summary:
;;; Commentary:
;;; Ivy UI integration with projectile.
;;; I added a custom counsel action that opens the project's root directory as a default
;;; switch project action. This behaviour was the default before, but was removed after
;;; an update. M-o (as all Ivy actions) have a larger set of actions now as well as part
;;; of that update.
;;; Code:

(defun counsel-projectile-switch-project-action-root-dir (project)
  "Open PROJECT root directory."
  (let ((projectile-switch-project-action
	 (lambda ()
	   (dired (projectile-project-root)))))
    (counsel-projectile-switch-project-by-name project)))

(use-package counsel-projectile
  :ensure t
  :bind ("C-x f" . counsel-projectile-find-file)
  :init
  (counsel-projectile-mode)
  :config
  (counsel-projectile-modify-action
   'counsel-projectile-switch-project-action
   '((add ("r" counsel-projectile-switch-project-action-root-dir "jump to a project root dir") 1))))

(provide 'init-counsel-projectile)
