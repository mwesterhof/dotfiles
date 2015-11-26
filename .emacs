(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)
(load-theme 'misterioso t)



; (require 'package)
;   (push '("marmalade" . "http://marmalade-repo.org/packages/")
;         package-archives )
;   (push '("melpa" . "http://melpa.milkbox.net/packages/")
;         package-archives)
;   (package-initialize)
; (require 'evil)
;   (evil-mode 0)
; (setq evil-emacs-state-cursor '("red" box))
; (setq evil-normal-state-cursor '("green" box))
; (setq evil-visual-state-cursor '("orange" box))
; (setq evil-insert-state-cursor '("red" bar))
; (setq evil-replace-state-cursor '("red" bar))
; (setq evil-operator-state-cursor '("red" hollow))
; (load-theme 'misterioso t)
