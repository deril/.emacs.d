;; Turn off mouse interface early in startup to avoid momentary display
(dolist (mode '(menu-bar-mode tool-bar-mode scroll-bar-mode))
  (when (fboundp mode) (funcall mode -1)))

;; Don't load the startup screen. It's obnoxious
(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)

;; Add the necessary directories to my load path. Some additional
;; dependencies unique to certain modes may also be loaded in their
;; respective files (e.g., I put the load path for the matlab-mode
;; installation in the startup file "setup-matlab-mode.el")
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/plugins/expand-region.el/")
(add-to-list 'load-path "~/.emacs.d/plugins/bbdb-2.35/lisp")

;; Set path to .emacs.d
(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))
(add-to-list 'load-path dotfiles-dir)

;; Load my custom elisp functions file
(load "my-functions.el")

;; Most of my initialization script has been split into separate files
;; in .emacs.d/ . Here they are...
(load "setup-org-mode")
(load "setup-ess-mode")
(load "setup-ido-mode")
(load "setup-matlab-mode")
(load "mac")
(load "key-bindings")

;; CUA mode is great. Adds many features I can't live without at this point
(cua-mode t)
(cua-selection-mode t)

;; Enable recent files mode to open recently opened files
(require 'recentf)
(recentf-mode 1)
;; 25 files ought to be enough.
(setq recentf-max-saved-items 25)

; I hate the audible alarm bell that emacs signals all the time. I
;; swtich to a visual bell here
(setq visible-bell 1)
;; To shut off the alarm bell completely, uncomment the following line
;; instead
;; (setq ring-bell-function 'ignore)

;; Add color to a shell running in emacs 'M-x shell'
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; This loads tab completion functionality much like Textmate
;; by sourcing the relevant file. Yay yasnippet!
(require 'yasnippet-bundle)
(yas/initialize)
(yas/load-directory "~/.emacs.d/snippets")

;; I should probably get rid of the following eventually and switch to
;; the new theme support built into Emacs 24+
(require 'color-theme)
(color-theme-initialize)
(setq color-theme-is-global t)
(color-theme-calm-forest)

;; Enable disabled commands
(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;; Ace-jump-mode. This minor mode provides quick navigation through
;; the buffer by jumping to target words, characters, or lines. The
;; mode is mainted on github at
;; https://github.com/winterTTr/ace-jump-mode. The keybinding is
;; defined in "key-bindings.el"  
(require 'ace-jump-mode)

;; The standard zap-to-char function kills up through and including
;; the provided letter. I'd prefer to have it NOT kill the provided
;; letter, but instead kill everything up to it, leaving point just
;; before the provided letter. This zap-up-to-char function provides
;; this functionality. I also bind it to the default key combo for
;; zap-to-char (in /key-bindings.el)
(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR.
  
  \(fn arg char)"
  'interactive)

;; Historically, the command C-x C-b calls the command (list-buffers) which 
;; opens a buffer called "*Buffer List*". iBuffer is a much improved
;; replacement. I reassign the default behavior of the command to use
;; iBuffer in key-bindings.el
(require 'ibuffer)

;; This bit of code creates an easy way to insert a filename (and its
;; path) into the buffer at point. 
(defun my-insert-file-name (filename &optional args)
  "Insert name of file FILENAME into buffer after point.
  
  Prefixed with \\[universal-argument], expand the file name to
  its fully canocalized path.  See `expand-file-name'.
  
  Prefixed with \\[negative-argument], use relative path to file
  name from current directory, `default-directory'.  See
  `file-relative-name'.
  
  The default with no prefix is to insert the file name exactly as
  it appears in the minibuffer prompt."
  ;; Based on insert-file in Emacs -- ashawley 20080926
  (interactive "*fInsert file name: \nP")
  (cond ((eq '- args)
	 (insert (file-relative-name filename)))
	((not (null args))
	 (insert (expand-file-name filename)))
	(t
	 (insert filename))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode t)
 '(TeX-view-program-list (quote (("SystemDefault" "open %o"))))
 '(TeX-view-program-selection (quote (((output-dvi style-pstricks) "dvips and gv") (output-dvi "xdvi") (output-pdf "SystemDefault") (output-html "SystemDefault"))))
 '(cua-mode t nil (cua-base))
 '(org-agenda-files (quote ("~/main/org/todo.org")))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; I have manually installed AUCTeX for latex management. It was
;; installed in Emacs.app/Contents/Resources/site-lisp, which is on
;; the load path already. Still, it must be loaded to be usable in
;; emacs: 
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

;; Some default behaviors and minor modes for use with AUCTeX mode
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;; htmlize for pretty conversion to html with syntax highlighting. See
;; also htmlfontify. I installed htmlize manually in
;; .emacs.d/plugins. This was necessary for org-mode export to html
;; for syntax highlighting of source code blocks
(require 'htmlize)
(put 'narrow-to-region 'disabled nil)

;; Start an emacs daemon. This allows other programs (or me, manually)
;; to open a file with an already running instantiation of
;; Emacs.app. Note that this is typically accomplished by running the
;; command "emacs --daemon" to start the emacs server, followed by
;; subsequent "emacsclient <file>" commands to pass files to a running
;; emacs process. For Emacs.app, the commands are
;; "/Applications/Emacs.app/Contents/MacOS/Emacs --daemon" and
;; "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient <file>"
;; respectively. Rather than start the server from the terminal, you
;; can also do so with a running emacs process with the command "M-x
;; server-start". Alternatively, you can run that command at startup,
;; which is what I've chosen to do below. Note that another option is
;; to have this happen at boot time on OS X. See this link for
;; details:
;; http://superuser.com/questions/50095/how-can-i-run-mac-osx-graphical-emacs-in-daemon-mode 
(require 'server)
(unless (server-running-p)
  (server-start))

;; This enables automatic (d)encryption of files ending in .gpg using
;; EasyPG, which is included in emacs as of version 23. I'm using this
;; encrypt my gnus passwords
(require 'epa-file) 
;; (epa-file-enable)
(setq epg-gpg-program "/usr/local/bin/gpg")  ;; I manually specify the binary files here

;; Mediawiki mode for wiki pages
(require 'mediawiki)

;; I want emacs to open URLs in Conkeror. As of <2012-05-31 Thu>, URL
;; remoting, as it's called in conkeror, doesn't work. That is, you
;; cannot specify a URL from the command line to conkeror on OS X. The
;; workaround was to set conkeror as my default browser and then use
;; the open command "open -a Conkeror http://www.example.com". Oddly,
;; I could not use CMD-i on an html file in Finder to set conkeror to
;; open all similar files. I had to open Safari, go to preferences,
;; and set Conkeror as the default web browser there.
(setq browse-url-browser-function 'browse-url-generic
browse-url-generic-program "open")

;; Set startup frame dimensions
;; (add-to-list 'default-frame-alist '(height . 90))
;; (add-to-list 'default-frame-alist '(width . 80))

;; Load haskell-mode files
(load "~/.emacs.d/plugins/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;; These indentation modes are mutually exclusive! Only activate
;; one of the following three lines!
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;; Expand region
(require 'expand-region)

;; An extended re-builder that supports perl regexs
(load "~/.emacs.d/plugins/re-builder-X")

;; The insidious big brother database
(setq bbdb-file "~/.emacs.d/bbdb")           ;; keep ~/ clean; set before loading
(require 'bbdb) 
(bbdb-initialize)
;; (bbdb-initialize 'gnus 'message)
;; (bbdb-insinuate-message)
(setq 
 bbdb-offer-save 1                        ;; 1 means save-without-asking

 
 bbdb-use-pop-up t                        ;; allow popups for addresses
 bbdb-electric-p t                        ;; be disposable with SPC
 bbdb-popup-target-lines  1               ;; very small
 
 bbdb-dwim-net-address-allow-redundancy t ;; always use full name
 bbdb-quiet-about-name-mismatches 2       ;; show name-mismatches 2 secs

 bbdb-always-add-address t                ;; add new addresses to existing...
 ;; ...contacts automatically
 bbdb-canonicalize-redundant-nets-p t     ;; x@foo.bar.cx => x@bar.cx

 bbdb-completion-type nil                 ;; complete on anything

 bbdb-complete-name-allow-cycling t       ;; cycle through matches
 ;; this only works partially

 bbbd-message-caching-enabled t           ;; be fast
 bbdb-use-alternate-names t               ;; use AKA


 bbdb-elided-display t                    ;; single-line addresses

 ;; auto-create addresses from mail
 bbdb/mail-auto-create-p 'bbdb-ignore-some-messages-hook   
 bbdb-ignore-some-messages-alist ;; don't ask about fake addresses
 ;; NOTE: there can be only one entry per header (such as To, From)
 ;; http://flex.ee.uec.ac.jp/texi/bbdb/bbdb_11.html

 '(( "From" . "no.?reply\\|DAEMON\\|daemon\\|facebookmail\\|twitter")))

;; Add bbdb GNUS hook
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
