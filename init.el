(require 'package)
(setq exec-path (append exec-path '("/usr/local/bin")))
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)

(require 'smooth-scrolling)
(smooth-scrolling-mode 1)

(setq mouse-wheel-scroll-amount '(1))

(set-language-environment "UTF-8")
(set-default-font
 (if (string-match "MBP" system-name)
     "Source Code Pro-10"
     "Source Code Pro-13"))

(setq-default comment-column 70)
(setq-default line-spacing 2)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; Enter cider mode when entering the clojure major mode
(add-hook 'clojure-mode-hook 'cider-mode)

;; Turn on auto-completion with Company-Mode
(global-company-mode)
(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)

;; Replace return key with newline-and-indent when in cider mode.
(add-hook 'cider-mode-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))

(show-paren-mode 1)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(add-to-list 'custom-theme-load-path "~/.emacs.d/lib/monokai-theme")
(load-theme 'monokai t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (magit paredit projectile smooth-scrolling helm-ag highlight-symbol rainbow-delimiters monokai-theme company cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq create-lockfiles nil)
(setq auto-save-default nil)
(setq backup-inhibited t)

(projectile-global-mode)

(blink-cursor-mode 0)

(setq ring-bell-function 'ignore)

(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(add-to-list 'auto-mode-alist '("\\.cleo\\'" . clojure-mode))
(setq-default indent-tabs-mode nil)
(setq c-default-style "linux"
      c-basic-offset 4)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
