;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Set google drive location based on machine
(cond ((string= (system-name) "pop-os")
       (setq gdrive_path "/home/sean/Insync/johnsen.s@husky.neu.edu/gdrive"))
      ((string= (system-name) "macos")
       (setq gdrive_path "/home/sean/Insync/johnsen.s@husky.neu.edu/gdrive")))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sean Johnsen"
      user-mail-address "sean.b.johnsen@gmail.com")

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
;;
;;(setq doom-theme 'doom-one)
(setq doom-theme 'doom-dracula)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory (format "%s/slipbox/" gdrive_path))

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

;; org-roam settings
(setq org-roam-directory (format "%s/slipbox/" gdrive_path))
(use-package! org-roam
  :config
  (org-roam-setup)
  (setq org-roam-capture-templates
        '(;; plain
          ("d" "default" plain "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n")
           :unnarrowed t)
          ;; bibliography note template
          ("r" "bibliography reference" plain "%?"
           :if-new
           (file+head "references/${citekey}.org" "#+title: ${title}\n")
           :unnarrowed t)))
  (org-roam-bibtex-mode))

;; bibtex-completion settings
(after! bibtex-completion
  (setq bibtex-completion-notes-path (format "%s/slipbox/" gdrive_path)
        bibtex-completion-bibliography (format "%s/zotero_library.bib" gdrive_path)
        bibtex-completion-pdf-field "file"))

;; org-ref settings
(use-package! org-ref
  :config
  (setq org-ref-completion-library 'org-ref-ivy-cite
        org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
        org-ref-default-bibliography (list (format "%s/zotero_library.bib" gdrive_path))
        org-ref-pdf-directory (format "%s/Zotero" gdrive_path)))

(setq reftex-default-bibliography (format "%s/zotero_library.bib" gdrive_path))

;; org-roam-bibtex settings
(use-package! org-roam-bibtex
  :after org-roam
  :config
  (require 'org-ref))



;; Disable Auto-format on save for certain file types
(setq +format-on-save-enabled-modes
      '(not org-mode))


(use-package! projectile
  :config
  (setq projectile-indexing-method 'native))

(use-package! org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; The WM can handle splits
   org-noter-notes-window-location 'other-frame
   ;; Please stop opening frames
   org-noter-always-create-frame nil
   ;; I want to see the whole file
   org-noter-hide-other nil
   ;; Everything is relative to the main notes file
   org-noter-notes-search-path (list (format "%s/slipbox/" gdrive_path))
   )
  )

(use-package! org-download
  :after org
  :config
  (setq-default org-download-image-dir "./images/"
                org-download-delete-image-after-download t
                org-download-method 'directory
                org-download-heading-lvl 1
                org-download-screenshot-file "/tmp/screenshot.png"))

(use-package! ox-reveal
  :config
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package! org-transclusion
  :config
  (setq
   org-transclusion-include-first-section t
   org-transclusion-exclude-elements '(keyword property-drawer)
   )
  :defer
  :after org
  :init
  (map!
   :map global-map "<f12>" #'org-transclusion-add
   :leader
   :prefix "n"
   :desc "Org Transclusion Mode" "t" #'org-transclusion-mode))
