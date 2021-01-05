;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "weichzh"
      user-mail-address "shx123qw@163.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;;(setq doom-font (font-spec :family "等距更砂黑体 Slab SC" :size 20 :weight 'regular))
;;(setq doom-variable-pitch-font (font-spec :family "更纱黑体 SC" :size 20))
;;(setq doom-unicode-font (font-spec :family "等距更砂黑体 Slab SC" :size 20))
;; 等距更砂黑体 Slab SC
(defun +my/better-font()
  (interactive)
  ;; english font
  (if (display-graphic-p)
      (progn
        (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" "Iosevka Slab" 20)) ;; 11 13 17 19 23
        ;; chinese font
        (dolist (charset '(kana han symbol cjk-misc bopomofo))
          (set-fontset-font (frame-parameter nil 'font)
                            charset
                            (font-spec :family "等距更纱黑体 Slab SC" :size 20)))) ;; 14 16 20 22 28
    ))

(defun +my|init-font(frame)
  (with-selected-frame frame
    (if (display-graphic-p)
        (+my/better-font))))

(if (and (fboundp 'daemonp) (daemonp))
    (add-hook 'after-make-frame-functions #'+my|init-font)
  (+my/better-font))

(setq doom-unicode-font (font-spec :family "等距更砂黑体 Slab SC" :size 20))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-material)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Note/org/")
(setq org-agenda-files '("~/Note/org/inbox.org"
                         "~/Note/org/gtd.org"
                         "~/Note/org/tickler.org"))
;; (setq org-todo-keywords
;;       '((sequence "[ ](t)" "[-](s)" "[?](w)" "|" "[X](d)")
;;         (sequence "|" "CANCELED(c)")))

;; (setq org-todo-keywords-for-agenda
;;       '("[ ]" "[-]" "[?]" "[X]" "CANCELED"))
(setq org-log-done 'time)



;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(add-hook 'window-setup-hook #'toggle-frame-maximized)

;; Set the TeX path. TODO add all shell envs.
(setenv "PATH"
        (concat
         "/usr/local/texlive/2020/bin/x86_64-linux" ":"
         (getenv  "PATH")
         )
    )
(let (
        (mypaths
         '(
           "/usr/local/texlive/2020/bin/x86_64-linux"
           ))
        )
    (setq exec-path (append exec-path mypaths) )
    )

;; Set proxy.
;;(setq url-gateway-method 'socks)
;;(setq socks-server '("Default server" "192.168.1.100" 7891 5))

;; Set default search engine. TODO change to a more sufficient way to use search engine.
(setq counsel-search-engine 'google)

;; A spell check tool, recommend by Chen Bin.
;(add-hook 'prog-mode-hook #'wucuo-start)
;(add-hook 'text-mode-hook #'wucuo-start)


;; Set the spell check backtend.
(setq ispell-program-name "aspell")
;; You could add extra option "--camel-case" for since Aspell 0.60.8
;; @see https://github.com/redguardtoo/emacs.d/issues/796
(setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together" "--run-together-limit=16"))



  ;; 使用xelatex一步生成PDF，不是org-latex-to-pdf-process这个命令
  (setq org-latex-pdf-process
        '(
	  "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	  "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	  "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	  "rm -fr %b.out %b.log %b.tex auto"
	  ))
  ;; 设置默认后端为 `xelatex'
  (setq org-latex-compiler "xelatex")


;;(provide 'vf-org-setting)
;; (add-hook 'LaTeX-mode-hook
;;           (lambda()
;;             (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
;;             (setq TeX-command-default "XeLaTeX")))

;; Set the rime input engine.
(use-package rime
  :custom
  (default-input-method "rime")
;;(rime--show-candidate 'minibuffer)
  (rime-show-candidate 'posframe)
  :config
  (setq rime-disable-predicates
        '(rime-predicate-evil-mode-p
          rime-predicate-after-alphabet-char-p
          rime-predicate-prog-in-code-p
          rime-predicate-in-code-string-p
          rime-predicate-evil-mode-p
          rime-predicate-ace-window-p
          rime-predicate-hydra-p
          rime-predicate-punctuation-after-space-cc-p
          rime-predicate-punctuation-after-ascii-p
          rime-predicate-punctuation-line-begin-p
          rime-predicate-space-after-cc-p
          rime-predicate-current-uppercase-letter-p
          rime-predicate-tex-math-or-command-p
          ))
  (setq rime-posframe-fixed-position t)
)

;; Solve the problem of Rime.
  (defun +rime--posframe-display-content-a (args)
    "给 `rime--posframe-display-content' 传入的字符串加一个全角空
格，以解决 `posframe' 偶尔吃字的问题。"
    (cl-destructuring-bind (content) args
      (let ((newresult (if (string-blank-p content)
                           content
                         (concat content "　"))))
        (list newresult))))

  (if (fboundp 'rime--posframe-display-content)
      (advice-add 'rime--posframe-display-content
                  :filter-args
                  #'+rime--posframe-display-content-a)
    (error "Function `rime--posframe-display-content' is not available."))

;; Set the popup rule.
;;(require 'ivy-posframe)
;; Different command can use different display function.
;;(setq ivy-posframe-display-functions-alist
 ;;     '((swiper          . ivy-display-function-fallback)
 ;;       (complete-symbol . ivy-posframe-display-at-point)
 ;;       (counsel-M-x     . ivy-posframe-display-at-window-bottom-left)
 ;;       (t               . ivy-posframe-display)))
;;(ivy-posframe-mode 1)

;; Set Evil-matchit to use 'm' instead of '%' .
(require 'evil-matchit)
(global-evil-matchit-mode 1)


;; Set Conda Environment.
;;(use-package conda
;;  :init
;; (setq conda-anaconda-home (expand-file-name "~/Src/anaconda3"))
;; (setq conda-env-home-directory (expand-file-name "~/Src/anaconda3")))
;;(add-hook 'python-mode-hook 'anaconda-mode)

;;(set-language-environment 'UTF-8)

;;(add-load-path! "/home/nick/.emacs.d/.local/straight/repos/emacs-application-framework")
;;(require 'eaf)

(defun insert-current-date()
  "Insert current date."
  (interactive "*")
  (insert (current-time-string)))

;; I'm defining a new face, though any face with underline should work
(defface my-nobreak-space
  '((t :inherit default :underline t))
  "My non-breaking space face.")

(font-lock-add-keywords 'python-mode '(("\u00a0" . 'my-nobreak-space)))
(add-hook 'org-mode-hook #'(lambda () (setq-local nobreak-char-display nil)))

(add-load-path! "/home/nick/.emacs.d/.local/straight/repos/gendoxy")
(load "gendoxy.el")

;;(require 'company)
;;(require 'gnome-shell-mode)
;;(require 'company-gnome-shell)

    ;; Most staight forward but might mess up company in other modes?
;;    (eval-after-load "company"
;;    (add-to-list 'company-backends 'company-gnome-shell))
