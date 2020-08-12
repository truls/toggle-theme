;;; toggle-theme.el --- Toggle themes -*- lexical-binding: t -*-
;;;
;;; Author:
;;; Truls Asheim <truls@asheim.dk>
;;;
;;; Commentary:
;;; Toggle light and dark mode
;;;
;;; Version: 1.0
;;; URL: https://github.com/truls/toggle-theme
;;;
;;; Package-Requires: ((emacs "24.4"))
;;;
;;; Code:
;;;

(defcustom toggle-theme-light-theme
  nil
  "The name of the light theme.")

(defcustom toggle-theme-dark-theme
  nil
  "The name of the dark theme.")

(defconst toggle-theme--get-theme-state-file
  (expand-file-name "theme-state" user-emacs-directory)
  "Location of theme state file")

(defun toggle-theme--write-theme-state-file (mode)
  "Write theme state to file. MODE is either 'light or 'dark."
  (with-temp-buffer
    (insert (case mode
             (dark "dark\n")
             (light "light\n")
             (otherwise (error "invalid argument"))))
    (write-file toggle-theme--get-theme-state-file)))

(defun toggle-theme--read-most-recent-theme ()
  "Reads the contents of the most recent theme file"
  (condition-case err
    (with-temp-buffer
      (insert-file-contents toggle-theme--get-theme-state-file)
      (string-trim (buffer-string)))
  (file-missing
     (toggle-theme--write-theme-state-file 'dark)
     "dark")))

(defun toggle-theme--get-most-recent-theme ()
  "Returns 'light or 'dark depending on most recent theme."
  (let
      ((mode (toggle-theme--read-most-recent-theme)))
    (cond
     ((string= mode "light") 'light)
     ((string= mode "dark") 'dark)
     (t (error "Invalid theme state file")))))

(defun toggle-theme-restore-theme ()
  "Loads the previously used theme."
  (case (toggle-theme--get-most-recent-theme)
    ('light
     (load-theme toggle-theme-light-theme t))
    ('dark
     (load-theme toggle-theme-dark-theme t))))

(defun toggle-theme ()
  "Toggles between light or dark theme."
  (interactive)
  (case (toggle-theme--get-most-recent-theme)
    ('light
     (toggle-theme--write-theme-state-file 'dark)
     (load-theme toggle-theme-dark-theme t))
    ('dark
     (toggle-theme--write-theme-state-file 'light)
     (load-theme toggle-theme-light-theme t))))

(provide 'toggle-theme)

;;; toggle-theme.el ends here
