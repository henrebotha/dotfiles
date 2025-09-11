;;; ...  -*- lexical-binding: t -*-

; https://nathantypanski.com/blog/2014-08-03-a-vim-like-emacs-config.html

(xterm-mouse-mode)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
; (package-refresh-contents)

(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
(require 'use-package)

(use-package evil-leader
  :commands (evil-leader-mode global-evil-leader-mode)
  :ensure evil-leader
  :demand evil-leader
  :config
  (progn
    (evil-leader/set-leader "<SPC>")
    (evil-leader/set-key "b" 'ibuffer)
    (evil-leader/set-key "e" 'pp-eval-last-sexp)
    (evil-leader/set-key "f" 'dired-jump)
    (global-evil-leader-mode)))

(use-package evil
  :after (evil-leader)
  :ensure evil
  :demand evil
  :config
  (progn
    (evil-mode 1)
    (setq evil-undo-system 'undo-redo)
    (evil-set-initial-state 'ibuffer-mode 'normal)
    (evil-define-key 'normal ibuffer-mode-map
      (kbd "j") 'evil-next-line
      (kbd "k") 'evil-previous-line
      (kbd "l") 'ibuffer-visit-buffer
      )
    (keymap-set evil-normal-state-map "C-h" 'evil-window-left)
    (keymap-set evil-normal-state-map "C-j" 'evil-window-down)
    (keymap-set evil-normal-state-map "C-k" 'evil-window-up)
    (keymap-set evil-normal-state-map "C-l" 'evil-window-right)
    )
  )

(use-package elisp-slime-nav
  :ensure elisp-slime-nav
  :demand elisp-slime-nav
  :config
  (progn
    (defun my-lisp-hook ()
      (elisp-slime-nav-mode)
      (turn-on-eldoc-mode)
      )
    (add-hook 'emacs-lisp-mode-hook 'my-lisp-hook)
    )
  )

(use-package goto-chg
  :ensure goto-chg
  :demand goto-chg
  )

(use-package consult
  :ensure consult
  :demand consult
  )

(require 'dired-x)
(eval-after-load 'dired
  '(progn
     (evil-define-key 'normal dired-mode-map "h" 'dired-up-directory)
     (evil-define-key 'normal dired-mode-map "l" 'dired-find-alternate-file)
     (evil-define-key 'normal dired-mode-map "o" 'dired-sort-toggle-or-edit)
     (evil-define-key 'normal dired-mode-map "v" 'dired-toggle-marks)
     (evil-define-key 'normal dired-mode-map "m" 'dired-mark)
     (evil-define-key 'normal dired-mode-map "u" 'dired-unmark)
     (evil-define-key 'normal dired-mode-map "U" 'dired-unmark-all-marks)
     (evil-define-key 'normal dired-mode-map "c" 'dired-create-directory)
     (evil-define-key 'normal dired-mode-map "n" 'evil-search-next)
     (evil-define-key 'normal dired-mode-map "N" 'evil-search-previous)
     (evil-define-key 'normal dired-mode-map "q" 'kill-this-buffer)
     )
   )

(visual-line-mode 1)
