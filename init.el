;;; init.el --- Emacs config of Ben Davies
;;; Commentary:

;; An Emacs configuration inspired by the features of emacs-live by
;; Sam Aaron.  A configuration for Clojure, Terraform, bash, and more.
;;
;; My goal here is to create a leaner configuration than emacs-live -
;; one that has similar useful minor modes and configuration for Clojure
;; but starts more quickly and allows me to use the latest cider (&
;; family).

;;; Code:

(delete-selection-mode 1) ; overwrite selected text when you type or paste
(global-auto-revert-mode 1) ; immediately reload a buffer if it changes on disk
(global-hl-line-mode 1) ; show a faint highlight on the current line
(icomplete-mode 1) ; show matching completions as you type in the minibuffer
(menu-bar-mode -1) ; hide the menu bar from emacs windows (File|Edit|Options...)
(toggle-scroll-bar -1) ; hide scrollbars in buffers
(tool-bar-mode -1) ; hide the toolbar (row of icons at the top of the window)
(recentf-mode 1) ; remember recently opened files
(savehist-mode 1) ; save minibuffer histories to suggest recently used files/functions/etc
(setq auto-save-default nil) ; turn off autosave on files
(setq column-number-mode t) ; include current column number in the modeline
(setq-default indent-tabs-mode nil) ; disable tabs for indentation
(setq inhibit-startup-screen t) ; don't show an Emacs start buffer
(setq load-prefer-newer t) ; prefer to load newer .el files over existing .elc (compiled) files
(setq make-backup-files nil) ; stop emacs creating backup copies of the file being edited
(setq warning-minimum-level :emergency) ; reduce warnings logged
(show-paren-mode 1) ; highlight matching pairs of parens
(add-hook 'before-save-hook 'delete-trailing-whitespace) ; fix trailing whitespace errors when saving
(defalias 'yes-or-no-p 'y-or-n-p) ; always allow y an n to mean yes and no
(add-to-list 'load-path "~/.emacs.d/elisp") ; allow custom scripts to be dropped in ~/.emacs.d/elisp

(set-face-attribute 'hl-line nil :inherit nil :background "#3e4446")
(set-face-background 'cursor "#00ede1")

;; Open emacs in full-screen
;; (add-hook 'window-setup-hook 'toggle-frame-maximised t)

;; Start repl with test
(setq cider-clojure-cli-global-options "-A:server:client:dev:test")

;; Prevent undo tree files from polluting your git repo
(setq undo-tree-auto-save-history nil)
;;(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

(setq visible-bell 1)
(setq ring-bell-function 'ignore)

;; Default working directory
(setq default-directory "~")

;; Don't show Emacs start up screen
(setq inhibit-startup-screen t)

;; Show line numbers
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; INSTALL MELPA STABLE

(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archive-priorities
     '(("melpa-stable" . 20)
       ("melpa" . 0)))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "DONE")))
(setq org-agenda-files (list "~/notes/work.org" "~/notes/home.org"))
(setq org-log-done t)

;; Neotree config
;; (add-to-list 'load-path "~/Documents/neotree")
;; (require neotree)
(global-set-key [f8] (lambda () (interactive) (`neotree-toggle)))
(setq neo-theme 'arrow)
(setq neo-smart-open t)

;; Split window into 3
(defun split-3-windows-horizontally-evenly ()
  (interactive)
  (command-execute 'split-window-horizontally)
  (command-execute 'split-window-horizontally)
  (command-execute 'balance-windows))
(global-set-key (kbd "C-x 4") 'split-3-windows-horizontally-evenly)

;; Switch focus to minibuffer
(defun switch-to-minibuffer-window ()
  "switch to minibuffer window (if active)"
  (interactive)
  (when (active-minibuffer-window)
    (select-frame-set-input-focus (window-frame (active-minibuffer-window)))
    (select-window (active-minibuffer-window))))
(global-set-key (kbd "C-x m") 'switch-to-minibuffer-window)


;;; INSTALL/CONFIGURE PACKAGES

(unless (package-installed-p 'auto-compile)
 (package-install 'auto-compile))
(auto-compile-on-load-mode)
(auto-compile-on-save-mode)

(unless (package-installed-p 'auto-complete)
 (package-install 'auto-complete))
(global-auto-complete-mode t)

(unless (package-installed-p 'browse-kill-ring)
 (package-install 'browse-kill-ring))

(unless (package-installed-p 'clojure-mode)
 (package-install 'clojure-mode))

(unless (package-installed-p 'cider)
 (package-install 'cider))
(setq cider-prompt-for-symbol nil) ; stop cider asking for confirmation before every C-. navigation
(setq cider-overlays-use-font-lock t)

(unless (package-installed-p 'clj-refactor)
 (package-install 'clj-refactor))
(setq cljr-magic-require-namespaces
     '(("async" . "clojure.core.async")
	("component" . "com.stuartsierra.component")
	("csk" . "camel-snake-kebab.core")
	("edn" . "clojure.edn")
	("far" . "taoensso.faraday")
	("fum" . "flatland.useful.map")
	("fus" . "flatland.useful.seq")
	("http" . "clj-http.client")
	("io" . "clojure.java.io")
	("json" . "cheshire.core")
	("jdbc" . "clojure.java.jdbc")
	("log" . "clojure.tools.logging")
	("memo" . "clojure.core.memoize")
	("s" . "schema.core")
	("set" . "clojure.set")
	("spec" . "clojure.spec.alpha")
	("str" . "clojure.string")
	("time" . "clj-time.core")
	("time-format" . "clj-time.format")
	("time-coerce" . "clj-time.coerce")
	("walk" . "clojure.walk")))

;; (setq cljr-inject-dependencies-at-jack-in nil)

(unless (package-installed-p 'highlight)
 (package-install 'highlight))
(unless (package-installed-p 'eval-sexp-fu)
 (package-install 'eval-sexp-fu))
(unless (package-installed-p 'cider-eval-sexp-fu)
 (package-install 'cider-eval-sexp-fu))
(require 'cider-eval-sexp-fu)

(load-theme 'misterioso)

(unless (package-installed-p 'dockerfile-mode)
 (package-install 'dockerfile-mode))

(unless (package-installed-p 'flx-ido)
 (package-install 'flx-ido))
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

(unless (package-installed-p 'flycheck)
 (package-install 'flycheck))
(add-hook 'after-init-hook #'global-flycheck-mode)

(unless (package-installed-p 'git-gutter)
 (package-install 'git-gutter))
(global-git-gutter-mode +1)

(unless (package-installed-p 'go-mode)
 (package-install 'go-mode))

(unless (package-installed-p 'goto-last-change)
 (package-install 'goto-last-change))
(global-set-key (kbd "C-c C-/") 'goto-last-change)

(unless (package-installed-p 'json-mode)
 (package-install 'json-mode))
(let ((width 2))
 (setq js-indent-level width)
 (setq json-reformat:indent-width width)
 (setq tab-width width))

(unless (package-installed-p 'magit)
 (package-install 'magit))

(unless (package-installed-p 'markdown-mode)
 (package-install 'markdown-mode))

;; (unless (package-installed-p 'nyan-mode)
;;   (package-install 'nyan-mode))
;; (nyan-mode)
;; (nyan-start-animation)

(unless (package-installed-p 'helm)
  (package-install 'helm))

(unless (package-installed-p 'paredit)
 (package-install 'paredit))

(unless (package-installed-p 'rainbow-delimiters)
 (package-install 'rainbow-delimiters))

(unless (package-installed-p 'smex)
 (package-install 'smex))
(smex-initialize)

(unless (package-installed-p 'string-inflection)
 (package-install 'string-inflection))
(require 'string-inflection)
(global-set-key (kbd "C-c C-u") 'string-inflection-upcase)
(global-set-key (kbd "C-c C-k") 'string-inflection-lisp)

(unless (package-installed-p 'swiper)
 (package-install 'swiper))

(unless (package-installed-p 'terraform-mode)
 (package-install 'terraform-mode))

(unless (package-installed-p 'tickscript-mode)
 (package-install 'tickscript-mode))

(unless (package-installed-p 'volatile-highlights)
 (package-install 'volatile-highlights))
(require 'volatile-highlights)
(volatile-highlights-mode t)

(unless (package-installed-p 'undo-tree)
 (package-install 'undo-tree))
(global-undo-tree-mode)

(unless (package-installed-p 'yaml-mode)
 (package-install 'yaml-mode))

(unless (package-installed-p 'exec-path-from-shell)
 (package-install 'exec-path-from-shell))

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(unless (package-installed-p 'which-key)
 (package-install 'which-key))
(require 'which-key)
(which-key-mode)

(unless (package-installed-p 'popwin)
 (package-install 'popwin))
(require 'popwin)
(popwin-mode 1)
(setq display-buffer-function 'popwin:display-buffer)
(setq popwin:special-display-config
     '(("*Help*"  :height 30)
       ("*Completions*" :noselect t)
       ("*Messages*" :noselect t :height 30)
       ("*Apropos*" :noselect t :height 30)
       ("*compilation*" :noselect t)
       ("*Backtrace*" :height 30)
       ("*Messages*" :height 30)
       ("*Occur*" :noselect t)
       ("*Ido Completions*" :noselect t :height 30)
       ("*magit-commit*" :noselect t :height 40 :width 80 :stick t)
       ("*magit-diff*" :noselect t :height 40 :width 80)
       ("*magit-edit-log*" :noselect t :height 15 :width 80)
       ("\\*ansi-term\\*.*" :regexp t :height 30)
       ("*shell*" :height 30)
       (".*overtone.log" :regexp t :height 30)
       ("*gists*" :height 30)
       ("*sldb.*":regexp t :height 30)
       ("*cider-error*" :height 30 :stick t)
       ("*cider-doc*" :height 30 :stick t)
       ("*cider-src*" :height 30 :stick t)
       ("*cider-result*" :height 30 :stick t)
       ("*cider-macroexpansion*" :height 30 :stick t)
       ("*Kill Ring*" :height 30)
       ("*Compile-Log*" :height 30 :stick t)
       ("*git-gutter:diff*" :height 30 :stick t)))

;;; CONFIGURE MODES

(add-hook 'cider-repl-mode-hook #'paredit-mode)

(add-hook 'clojure-mode-hook #'paredit-mode)
(add-hook 'clojure-mode-hook #'eldoc-mode)
(add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook #'clj-refactor-mode)

(add-hook 'emacs-lisp-mode-hook #'paredit-mode)
(add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)

(add-hook 'json-mode-hook #'paredit-mode)
(add-hook 'json-mode-hook #'rainbow-delimiters-mode)

(add-hook 'terraform-mode-hook #'paredit-mode)
(add-hook 'terraform-mode-hook #'rainbow-delimiters-mode)

;;; ADDITIONAL FUNCTIONS

(defun delete-all-horizontal-space ()
 "Deletes all horizontal space between two symbols."
 (interactive)
 (just-one-space -1)
 (delete-backward-char 1))

(defun paredit-delete-horizontal-space ()
 "Deletes all horizontal space between two sexps in paredit mode."
 (interactive)
 (just-one-space -1)
 (paredit-backward-delete))

;;; ADDITIONAL BINDINGS

(global-set-key (kbd "C-x C-<left>") 'windmove-left)
(global-set-key (kbd "C-x C-<right>") 'windmove-right)
(global-set-key (kbd "C-x C-<up>") 'windmove-up)
(global-set-key (kbd "C-x C-<down>") 'windmove-down)
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "M-\\") 'delete-all-horizontal-space)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(global-set-key (kbd "C-x g") 'magit-status)

;;; Magit Hooks

;; reload magit after save
(with-eval-after-load 'magit-mode
 (add-hook 'after-save-hook 'magit-after-save-refresh-status t))

(require 'paredit)
(define-key paredit-mode-map (kbd "M-[") 'paredit-wrap-square)
(define-key paredit-mode-map (kbd "M-{") 'paredit-wrap-curly)
(define-key paredit-mode-map (kbd "M-T") 'transpose-sexps)
(define-key paredit-mode-map (kbd "M-\\") 'paredit-delete-horizontal-space)

(require 'cider)
(define-key cider-mode-map (kbd "C-c M-q") 'cider-quit)
(define-key cider-repl-mode-map (kbd "C-c M-q") 'cider-quit)
(define-key cider-mode-map (kbd "C-c M-r") 'sesman-restart)
(define-key cider-repl-mode-map (kbd "C-c M-r") 'sesman-restart)

(global-set-key (kbd "C-c C-l") 'cider-load-all-project-ns)

(global-set-key (kbd "C-x C-x") 'cider-pprint-eval-last-sexp-to-comment)

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ignored-local-variable-values '((cider-test-default-exclude-selectors "e2e")))
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-even-diff-A ((((class color) (background dark)) (:background "dark green"))))
 '(ediff-even-diff-B ((((class color) (background dark)) (:background "dark red"))))
 '(ediff-odd-diff-A ((((class color) (background dark)) (:background "dark green"))))
 '(ediff-odd-diff-B ((((class color) (background dark)) (:background "dark red"))))
 '(mumamo-background-chunk-major ((((class color) (background dark)) (:background "black"))))
 '(mumamo-background-chunk-submode1 ((((class color) (background dark)) (:background "black")))))

(setq visible-bell 1)
(setq ring-bell-function 'ignore)
