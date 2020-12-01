(require 'package)
(setq exec-path (append exec-path '("/usr/local/bin")))
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)

(global-auto-revert-mode t)
(setq inhibit-startup-screen t)

(require 'smooth-scrolling)
(smooth-scrolling-mode 1)

(setq mouse-wheel-scroll-amount '(1))

(windmove-default-keybindings 'super)

(set-language-environment "UTF-8")
(set-frame-font
 (if (string-match "MBP" system-name)
     "Iosevka-11"
     "Iosevka-13") nil t)

(setq mac-function-modifier 'hyper)
(define-key global-map (kbd "H-j") 'left-char)
(define-key global-map (kbd "H-l") 'right-char)
(define-key global-map (kbd "H-k") 'next-line)
(define-key global-map (kbd "H-i") 'previous-line)
(define-key global-map (kbd "H-M-j") 'left-word)
(define-key global-map (kbd "H-M-l") 'right-word)

(global-set-key (kbd "C-?") 'help-command)
(global-set-key (kbd "S-h") 'mark-paragraph)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "M-h") 'backward-kill-word)

(setq-default comment-column 70)
(setq-default line-spacing 2)

(setq column-number-mode t)

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
 '(markdown-command "pandoc")
 '(package-selected-packages
   (quote
    (exec-path-from-shell ninja-mode markdown-mode magit paredit projectile smooth-scrolling helm-ag highlight-symbol rainbow-delimiters monokai-theme company cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq create-lockfiles nil)
(setq auto-save-default nil)
(setq backup-inhibited t)

(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)

(projectile-global-mode)

(blink-cursor-mode 0)

(setq ring-bell-function 'ignore)

(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(add-to-list 'auto-mode-alist '("\\.cleo\\'" . clojure-mode))
(setq-default indent-tabs-mode nil)
(setq c-default-style "linux"
      c-basic-offset 4)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq load-path (cons "~/.emacs.d/glsl-mode" load-path))
(autoload 'glsl-mode "glsl-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.geom\\'" . glsl-mode))

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)

(cl-flet ((up (p) (directory-file-name (file-name-directory p))))
  (let* ((bin-path
          (up (file-truename "/usr/local/bin/erl")))
         (root-path
          (up (up (up bin-path))))
         (erl-load-path
          (car (file-expand-wildcards (concat root-path "/lib/erlang/lib/tools-*/emacs")))))
    (setq load-path (cons erl-load-path load-path))
    (setq erlang-root-dir root-path)
    (setq exec-path (cons bin-path exec-path))))

(require 'erlang-start)
(put 'downcase-region 'disabled nil)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(defun asm-left-flush-directives (orig-fun &rest args)
  (or
   (and (looking-at "\\.\\(\\sw\\|\\s_\\)+") 0)
   (and (looking-at "@+\\(\\sw\\|\\s_\\)+:") 0)
   (apply orig-fun args)))

(with-eval-after-load "asm-mode"
  (advice-add 'asm-calculate-indentation :around #'asm-left-flush-directives)
  (setq asm-font-lock-keywords
        (cons '("^\\(@+\\(\\sw\\|\\s_\\)+\\)\\>:"
                1 font-lock-function-name-face)
              (mapcar (lambda (entry)
                        (if (string-equal (car entry) "^\\(\\.\\(\\sw\\|\\s_\\)+\\)\\>[^:]?")
                            (cons (car entry) '(1 font-lock-function-name-face))
                          entry)) asm-font-lock-keywords)))
  (defun improve-asm-font-lock-defaults ()
    (set (make-local-variable 'font-lock-defaults) '(asm-font-lock-keywords)))
  (add-hook 'asm-mode-hook 'improve-asm-font-lock-defaults))


(defun asm-period-key ()
  "Insert a colon; if it follows a label, delete the label's indentation."
  (interactive)
  (let ((directivep nil))
    (save-excursion
      (skip-syntax-backward " ")
      (if (setq directivep (bolp)) (delete-horizontal-space)))
    (call-interactively 'self-insert-command)))

(defun expand-asm-keymap ()
  (define-key asm-mode-map "." 'asm-period-key))

(add-hook 'asm-mode-set-comment-hook 'expand-asm-keymap)
