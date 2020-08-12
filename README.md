# theme-toggle.el

Provides the function `toggle-theme` for toggling between two themes
in emacs. Use the function `toggle-theme--restore-theme` to load the
previously used theme. Customize the variables
`toggle-theme-light-theme` and `toggle-theme-dark-theme` with then
name of the theme that should be passed to the load-theme function.

Usage example:
```;;
;; Dark/light theme toggeling
;;
(use-package toggle-theme
  :config
  (setq toggle-theme--light-theme 'immaterial-light
        toggle-theme--dark-theme 'immaterial-dark))

;;
;; Use immaterial theme
;;
(use-package immaterial-theme
  :ensure t
  :config
  (toggle-theme--restore-theme))
```
