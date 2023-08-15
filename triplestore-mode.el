;;; triplestore-mode.el --- Minor mode to work on a live RDF Triplestore  -*- lexical-binding: t; -*-

;; Copyright (C) 2023 virtual earth Gesellschaft für Wissens re/prä sentation mbH

;; Author: Mathias Picker <Mathias.Picker@virtual-earth.de>
;; URL: https://virtual-earth.de/elisp/package-name.el
;; Version: 0.1-pre
;; Package-Requires: ((emacs "25.2"))
;; Keywords: RDF

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package handles connections to triplestores for hopefully many RDF-related major modes

;;;; Installation

;;;;; MELPA

;; If you installed from MELPA, you're done.

;;;;; Manual

;; Install these required packages:

;; + foo
;; + bar

;; Then put this file in your load-path, and put this in your init
;; file:

;; (require 'package-name)

;;;; Usage

;; Run one of these commands:

;; `package-name-command': Frobnicate the flange.

;;;; Tips

;; + You can customize settings in the `triplestore-mode' group.

;;;; Credits

;; This package would not have been possible without the following
;; packages: ttl-mode[1], which showed me how to syntax highlight turtle, and restclient.el[2],
;; which taught me about working with http and displaying return values in a
;; buffer and cider[3], which showed me how to handle multiple connections using
;; sesman[4] and influenced my understanding of an interactive development environment.
;;
;;  [1] https://github.com/nxg/ttl-mode
;;  [2] https://github.com/pashky/restclient.el
;;  [3] https://cider.mx/
;;  [4] https://github.com/vspinu/sesman/

;;; Code:

;;;; Requirements

;; (require 'foo)
;; (require 'bar)

;;;; Customization

(defgroup triplestore-mode nil
  "Settings for `triplestore-mode'."
  :link '(url-link "https://github.com/virtual-earth-de/triplestore-mode.el"))

(defcustom triplestore-mode-something nil
  "This setting does something."
  :type 'something)

;;;; Variables

;;; temporary solution: current "connection"
(defvar triplestore-mode-connection '((type . blazegraph) (url . "http://localhost:9999/"))
  "A variable.")

;; blazegraph uses HOST/blazegraph/namespace/[NAMESPACE]/sparql for queries,
;; with 'undefined' for NAMESPACE if no actual namespace is given.

;;;;; Keymaps

;; This technique makes it easier and less verbose to define keymaps
;; that have many bindings.

(defvar triplestore-mode-map
  ;; This makes it easy and much less verbose to define keys
  (let ((map (make-sparse-keymap "triplestore-mode map"))
        (maps (list
               ;; Mappings go here, e.g.:
               "RET" #'package-name-RET-command
               [remap search-forward] #'package-name-search-forward
               )))
    (cl-loop for (key fn) on maps by #'cddr
             do (progn
                  (when (stringp key)
                    (setq key (kbd key)))
                  (define-key map key fn)))
    map))

;;;; Commands

;;;###autoload
(defun triplestore-mode ()
  "Activate triplestore mode in current buffer."
  (interactive)
  (triplestore-mode-activate))

;;;; Functions

;;;;; Public

(defun triplestore-mode-activate ()
  "Return foo for ARGS."
  (message "So aktiviert man ein neues Modul..."))

;;;;; Private

(defun triplestore-mode--bar (args)
  "Return bar for ARGS."
  (bar args))

;;;; Footer

(provide 'triplestore-mode)

;;; triplestore-mode.el ends here
