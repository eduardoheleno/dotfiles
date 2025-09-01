;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'minimal)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq doom-theme 'doom-gruvbox)

(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq doom-font (font-spec :family "FantasqueSansM Nerd Font Mono" :size 20)
      doom-variable-pitch-font (font-spec :family "FantasqueSansM Nerd Font Mono" :size 20))

;; In ~/.doom.d/init.el
(setq doom-tabs-enable nil)  ;; Disable tabs if you want to use spaces
(setq-default tab-width 4)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq c-default-style "linux")
(setq c-basic-offset 4)
(c-set-offset 'comment-intro 0)

(setenv "PATH" (concat "/home/eduardo/.local/bin:" (getenv "PATH")))
(setenv "PATH" (concat "/usr/local/go/bin:" (getenv "PATH")))

(add-to-list 'exec-path "/home/eduardo/.local/bin")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq explicit-shell-file-name "/usr/bin/fish")  ; Replace with the correct path to fish if it's different
(setq shell-file-name "fish")  ; Optional: to ensure it's used by shell commands

(setq +latex-viewers '(pdf-tools))

(windmove-default-keybindings)
(setq doom-modeline-modal nil) ;; Disable Evil mode status display

(global-anzu-mode +1)

(require 'powerline)
(require 'spaceline-config)

(spaceline-define-segment my-vc
  "Version control information."
  (when vc-mode
    (powerline-raw
     (s-trim (concat
              (substring vc-mode 5)
              (when (buffer-file-name)
                (pcase (vc-state (buffer-file-name))
                  (`up-to-date "")
                  (`edited "*"))))))))

(defun my-custom-spaceline ()
  (setq powerline-default-separator nil)

  (setq window-divider-default-bottom-width 0)
  (setq window-divider-default-places 'bottom-only)

  (spaceline-compile
   'my-custom-line
   ;; Left side segments, including version control
   '((buffer-modified buffer-id my-vc))
   '(
     (point-position line-column)))
   ;; '((point-position line-column))
   ;; ;; Right side segments
   ;; '((global) :face 'warning)
   ;; '((buffer-encoding major-mode)))

  ;; Set the custom line as the default mode-line
  (setq-default mode-line-format '("%e" (:eval (spaceline-ml-my-custom-line)))))

(defun open-org-home ()
  "Open org home file."
  (interactive)
  (find-file "~/Dropbox/org-sync/home.org"))

(map! :leader
      :desc "Open org home file"
      "o o" #'open-org-home)

(my-custom-spaceline)

(doom/set-frame-opacity 90)
