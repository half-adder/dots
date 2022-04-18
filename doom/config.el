;; $DOOMDIR/confg.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Set google drive location based on machine
(cond ((string= (system-name) "pop-os")
       (setq gdrive_path "/home/sean/Insync/johnsen.s@husky.neu.edu/gdrive"))
      ((string= (system-name) "macos")
       (setq gdrive_path "/home/sean/Insync/johnsen.s@husky.neu.edu/gdrive"))
      ((string= (system-name) "DESKTOP-K1252K3")
       (setq gdrive_path "/mnt/g/My Drive")))

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
(setq org-directory (format "%s/org/" gdrive_path))

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


;; org-mode settings
(use-package! org
  :config
  (require 'org-inlinetask)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "WORKING(w)" "|" "DONE(d)")
          (sequence "READ(r)" "INTEGRATE(i)" "|" "PROCESSED(p)")))

  (setq org-todo-keyword-faces
        '(("TODO" :foreground "red" :weight bold)
          ("WORKING" :foreground "yellow" :weight bold)
          ("DONE" :foreground "green" :weight bold)))

  (setq org-publish-project-alist
        `(("lab-notebook-notes"
           :base-directory ,(format "%s/org/mckay_lab_notebook/" gdrive_path)
           :recursive t
           :auto-sitemap t
           :sitemap-title "Sitemap"
           :base-extension "org"
           :publishing-function org-html-publish-to-html
           :publishing-directory "~/Desktop/mckay_lab_notebook-export/")
          ("lab-notebook-static"
           :base-directory ,(format "%s/org/mckay_lab_notebook/" gdrive_path)
           :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|JPEG\\|jpeg\\|JPG"
           :publishing-directory "~/Desktop/mckay_lab_notebook-export/"
           :recursive t
           :publishing-function org-publish-attachment)
          ("lab-notebook"
           :components ("lab-notebook-notes" "lab-notebook-static"))

          ("slipbox-notes"
           :base-directory ,(format "%s/org/slipbox/" gdrive_path)
           :recursive t
           :auto-sitemap t
           :sitemap-title "Sitemap"
           :base-extension "org"
           :publishing-function org-html-publish-to-html
           :publishing-directory "~/Desktop/slipbox-export")
          ("slipbox-static"
           :base-directory ,(format "%s/org/slipbox/" gdrive_path)
           :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|JPEG\\|jpeg\\|JPG"
           :publishing-directory "~/Desktop/slipbox-export/"
           :recursive t
           :publishing-function org-publish-attachment)
          ("slipbox"
           :components ("slipbox-notes", "slipbox-static"))))

  (setq org-agenda-files (list
                          (format "%s/org/mckay_lab_notebook/tasks.org" gdrive_path)
                          (format "%s/org/mckay_lab_notebook/projects/PcG_initiation_project/notebook.org" gdrive_path)))
  (setq org-capture-templates
        `(("t" "Todo" entry
           (file+headline ,(format "%s/org/mckay_lab_notebook/tasks.org" gdrive_path) "Inbox")
           "* TODO %?")))
  )

;; org-roam settings
(use-package! org-roam
  :config
  (setq org-roam-directory (format "%s/org/slipbox/" gdrive_path))
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
  (setq org-roam-dailies-directory "meeting/")
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "* %?"
           :if-new (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n"))))
  )

;; biblio settings
(use-package! citar
  :config
  (setq citar-bibliography (list (format "%s/zotero_library.bib" gdrive_path))
        citar-library-paths (list (format "%s/Zotero/" gdrive_path))
        citar-notes-paths (list (format "%s/org/slipbox/references/" gdrive_path))
        citar-symbols `((file ,(all-the-icons-faicon "file-o" :face 'all-the-icons-green :v-adjust -0.1) . " ")
                        (note ,(all-the-icons-material "speaker_notes" :face 'all-the-icons-blue :v-adjust -0.3) . " ")
                        (link ,(all-the-icons-octicon "link" :face 'all-the-icons-orange :v-adjust 0.01) . " "))
        citar-symbol-separator "  "
        org-cite-csl-styles-dir (format "%s/biblio/styles" gdrive_path)
        org-cite-csl-locales-dir (format "%s/biblio/locales" gdrive_path)
        org-cite-global-bibliography (list (format "%s/zotero_library.bib" gdrive_path)))
  )

;; Disable Auto-format on save for certain file types
(setq +format-on-save-enabled-modes
      '(not org-mode))

;;(use-package! deft
;;  :config
;;  (setq deft-directory (format "%s/slipbox/" gdrive_path))
;;  (setq deft-recursive t)
;;  (setq deft-use-filter-string-for-filename t)
;;  (setq deft-default-extension "org"))

(use-package! projectile
  :config
  (setq projectile-indexing-method 'native)
  (setq projectile-project-search-path (list "~/code" (format "%s/org/" gdrive_path)))
  )

(use-package! org-download
  :after org
  :config
  (setq-default org-download-image-dir "./images/"
                org-download-delete-image-after-download t
                org-download-method 'directory
                org-download-heading-lvl 1
                org-download-screenshot-file "/tmp/screenshot.png"))

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

(use-package! ox-hugo
  :config
  (setq org-hugo-base-dir "~/code/personal_site"))

;; elfeed config
(setq rmh-elfeed-org-files (list (format "%s/org/elfeed.org" gdrive_path)))

;; writeroom-mode
;;(setq doom-variable-pitch-font (font-spec :family "Vollkorn" :size 12))

;; Org Super-Agenda
(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-super-agenda-groups '((:log t)
                                  (:auto-group t)
                                  ))
  (setq org-agenda-custom-commands
        '(("g" "Get Things Done (GTD)"
           ((agenda ""
                    ((org-agenda-skip-function
                      '(org-agenda-skip-entry-if 'deadline))
                     (org-deadline-warning-days 0)))
            (todo "NEXT"
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline))
                   (org-agenda-prefix-format "  %i %-12:c [%e] ")
                   (org-agenda-overriding-header "\nTasks\n")))
            (agenda nil
                    ((org-agenda-entry-types '(:deadline))
                     (org-agenda-format-date "")
                     (org-deadline-warning-days 7)
                     (org-agenda-skip-function
                      '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
                     (org-agenda-overriding-header "\nDeadlines")))
            (tags-todo "inbox"
                       ((org-agenda-prefix-format "  %?-12t% s")
                        (org-agenda-overriding-header "\nInbox\n")))
            (tags "CLOSED>=\"<today>\""
                  ((org-agenda-overriding-header "\nCompleted today\n")))))))
  :config
  (org-super-agenda-mode))

(use-package! org-journal
  :after org
  :config
  (setq org-journal-file-type 'monthly))



;; EXPERIMENTAL
;; Determine the specific system type.
;; Emacs variable system-type doesn't yet have a "wsl/linux" value,
;; so I'm front-ending system-type with my variable: sysTypeSpecific.
;; I'm no elisp hacker, so I'm diverging from the elisp naming convention
;; to ensure that I'm not stepping on any pre-existing variable.
(setq-default sysTypeSpecific  system-type) ;; get the system-type value

(cond
 ;; If type is "gnu/linux", override to "wsl/linux" if it's WSL.
 ((eq sysTypeSpecific 'gnu/linux)
  (when (string-match "WSL2"
                      (shell-command-to-string "uname -a"))

    (setq-default sysTypeSpecific "wsl/linux") ;; for later use.
    (setq
     cmdExeBin"/mnt/c/Windows/System32/cmd.exe"
     cmdExeArgs '("/c" "start" "") )
    (setq
     browse-url-generic-program  cmdExeBin
     browse-url-generic-args     cmdExeArgs
     browse-url-browser-function 'browse-url-generic)
    )))
