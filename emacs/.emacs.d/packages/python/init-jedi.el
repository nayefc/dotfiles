(defun jedi:goto-definition-same-frame ()
  "Jedi goto-definition wrapper to go to definition directly."
  (interactive)
  (jedi:goto-definition nil `definition))

(defun jedi:goto-definition-new-frame ()
  "Jedi goto-definition wrapper in a new, nexts frame."
  (interactive)
  (jedi:goto-definition 1 `definition))

(use-package jedi
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :commands jedi:setup
  :bind (:map python-mode-map
	 ("C-c k" . jedi:goto-definition-same-frame)
         ("C-c ;" . jedi:goto-definition-new-frame)
         ("C-c '" . jedi:goto-definition)
         ("C-c j" . jedi:goto-definition-pop-marker)
         ("C-c ?" . jedi:show-doc)
	 ("M-/" . jedi:get-in-function-call))
  :init
  (setq jedi:complete-on-dot t)
  (setq jedi:tooltip-method nil)
  (add-hook 'python-mode-hook 'jedi:setup)
  :config
  (bind-keys :map jedi-mode-map
             ("C-c ." . nil)
             ("C-c ," . nil)
             ("C-c /" . nil)))

(use-package company-jedi
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :defines company-backends
  :config
  (add-to-list 'company-backends '(company-jedi company-files)))


(provide 'init-jedi)
