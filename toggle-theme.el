;;; toggle-theme.el --- Toggle themes in emacs -*- lexical-binding: t -*-
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

(defcustom toggle-theme--light-theme
  "The name of the light theme."
  'immaterial-light)

(defcustom toggle-theme--dark-theme
  "The name of the dark theme."
  'immaterial-dark)

(defconst toggle-theme--get-theme-state-file
  "Location of theme state file"
  (expand-file-name "theme-state" user-emacs-directory))

(defun toggle-theme--write-theme-state-file (mode)
  "Write theme state to file. MODE is either 'light or 'dark."
  (with-temp-buffer
    (insert (case mode
             (dark "dark\n")
             (light "light\n")
             (otherwise (error "invalid argument"))))
    (write-file my/get-theme-state-file)))

(defun toggle-theme--read-most-recent-theme ()
  "Reads the contents of the most recent theme file"
  (condition-case err
    (with-temp-buffer
      (insert-file-contents my/get-theme-state-file)
      (string-trim (buffer-string)))
  (file-missing
     (my/write-theme-state-file 'dark)
     "dark")))

(defun toggle-theme--get-most-recent-theme ()
  "Returns 'light or 'dark depending on most recent theme."
  (let
      ((mode (my/read-most-recent-theme)))
    (cond
     ((string= mode "light") 'light)
     ((string= mode "dark") 'dark)
     (t (error "Invalid theme state file")))))

(defun toggle-theme-restore-theme ()
  "Loads the previously used theme."
  (case (my/get-most-recent-theme)
    ('light
     (load-theme 'immaterial-light t))
    ('dark
     (load-theme 'immaterial-dark t))))

(defun toggle-theme ()
  "Toggles between light or dark theme."
  (interactive)
  (case (my/get-most-recent-theme)
    ('light
     (my/write-theme-state-file 'dark)
     (load-theme 'immaterial-dark t))
    ('dark
     (my/write-theme-state-file 'light)
     (load-theme 'immaterial-light t))))

(provide 'toggle-theme)

;;; toggle-theme.el ends here
