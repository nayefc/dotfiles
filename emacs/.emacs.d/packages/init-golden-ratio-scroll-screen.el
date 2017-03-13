(use-package golden-ratio-scroll-screen
  :ensure t
  :init
  (setq golden-ratio-scroll-screen-ratio 1.02)
  (setq golden-ratio-scroll-highlight-flag 'before)
  (global-set-key [remap scroll-down-command] 'golden-ratio-scroll-screen-down)
  (global-set-key [remap scroll-up-command] 'golden-ratio-scroll-screen-up))

(provide 'init-golden-ratio-scroll-screen)
