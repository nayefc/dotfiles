(use-package multiple-cursors
  :ensure t
  :bind (("C-c ." . mc/mark-next-like-this)
         ("C-c ," . mc/mark-previous-like-this)
         ("C-c c" . mc/edit-lines)
         ("C-c /" . mc/mark-all-like-this)))

(provide 'init-multiple-cursors)
