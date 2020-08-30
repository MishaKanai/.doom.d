;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org")
(setq org-roam-directory "~/Dropbox/org/roam")

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
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))

(require 'org-roam-protocol)

(use-package org-roam-server
  :ensure t
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))

;; (defun cam/preview-markdown ()
  ;; (interactive)
  ;; (message "Rendering Markdown preview of %s" buffer-file-name)
  ;; (shell-command-on-region (point-min) (point-max) "pandoc -f gfm" "*Preview Markdown Output*"))
(defun cam/preview-markdown ()
  (interactive)
  ;; [1] bind the value of buffer-file-name to local variable filename
  (let ((filename buffer-file-name))
    (message "Rendering Markdown preview of %s" filename)
    (shell-command-on-region (point-min) (point-max) "pandoc -f gfm" "*Preview Markdown Output*")
    ;; [2] switch to a different window and bring up the *Preview Markdown Output* buffer
    (switch-to-buffer-other-window "*Preview Markdown Output*")
    ;; [3] Parse the HTML source in *Preview Markdown Output* and store it in document
    (let ((document (libxml-parse-html-region (point-min) (point-max))))
      ;; [4] Clear the contents of *Preview Markdown Output*
      (erase-buffer)
      ;; [5] Render the parsed HTML into *Preview Markdown Output*
      (shr-insert-document document)
      ;; [6] Movew back to the beginning of the buffer
      (goto-char (point-min)))
      )
  )

(defun misha/create-graph-buffer ()
  (interactive)
  (let ((filename "~/Dropbox/org/roam/graph.dot"))
    (switch-to-buffer (get-buffer-create "*mishares*"))
    (kill-region (point-min) (point-max))
         (goto-char (point-min))
         (insert (org-roam-graph--dot `[:select [file title] :from titles
                           ,@(org-roam-graph--expand-matcher 'file t)
                           :group :by file]))
         (write-region (point-min) (point-max) filename)
         (find-file-noselect filename)
    )
  )


(package-install-file "~/Downloads/org-krita-0.1.1.tar")
