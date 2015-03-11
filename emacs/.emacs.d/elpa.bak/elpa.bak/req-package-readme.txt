Description

req-package is a macro wrapper on top of use-package.
It's goal is to simplify package dependencies management,
when using use-package for your .emacs.

Usage

1) Load req-package:

   (require 'req-package)

2) Define required packages with dependencies using :require like this:

   (req-package dired) ;; you can omit this empty requirement because of dired-single

   (req-package dired-single
     :require dired
     :config (...))

   (req-package lua-mode
     :config (...))

   (req-package flymake)

   (req-package flymake-lua
     :require (flymake lua-mode)
     :config (...))

3) To start loading packages in right order:

   (req-package-finish)

Migrate from use-package

   Just replace all (use-package ...) with (req-package [:require DEPS] ...)
   and add (req-package-finish) at the end of your configuration file.

Note

   All use-package parameters are supported, see use-package manual for additional info.

   However there is now need of :ensure keyword usage. req-package will add it automatically if needed.

   Also there is a req-package-force function which simulates plain old use-package behavior

   More complex req-package usage example can be found at http://github.com/edvorg/emacs-configs.

Changelog:

   v0.5:
      Major system refactoring.
      Fixed bugs with defered loading.
      Significant performance optimization.
      max-specpdl-size, max-lisp-eval-depth issues completely solved.
      Flexible :require keyword parsing.
   v0.4.2:
      Bug fixes.
   v0.4.1:
      Various tweaks and bug fixes.
   v0.4-all-cycles:
      All cycles of your dependencies will be printed.
      Also there are more handy log messages and some bug fixes.
   v0.3-cycles:
      There are nice error messages about cycled dependencies now.
      Cycles printed in a way: pkg1 -> [pkg2 -> ...] pkg1.
      It means there is a cycle around pkg1.
   v0.2-auto-fetch:
      There is no need of explicit :ensure in your code now.
      When you req-package it adds :ensure if package is available in your repos.
      Also package deps :ensure'd automatically too.
      Just write (req-package pkg1 :require pkg2) and all you need will be installed.
