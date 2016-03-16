(use-package expand-region
  :ensure t
  :bind (("C-c m" . er/expand-region)
	 ("C-x m" . er/mark-outer-python-block)
	 ("C-x /" . er/mark-inside-python-string)
	 ("C-x \\" . er/mark-outside-python-string)
	 ("C-x l" . er/mark-python-statement)
	 ("C-x h" . er/mark-inside-pairs)
	 ("C-x j" . er/mark-outside-pairs)))

(provide 'init-expand-region)
