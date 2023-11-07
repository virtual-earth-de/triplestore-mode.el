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

;;; we need to find some things at point
;;; <2023-08-15 Di.> later, for now it's enough to manipulate the syntax table (see below)

(defun QName--bound-of-QName-at-point ()
  "Return the start and end points of a QName at the current point.
A QName is an abbreviated URL, see the RDF specifications. 
The result is a paired list of max and min character positions of 
the QName in the current buffer."
  (0 1))

(put 'QName'bounds-of-thing-at-point #'QName-bound-of-QName-at-point) 

;;; end of thing-at-points extension

;;; experiment with fake eldoc function

;; Oh fudge, I have to expand the defined prefixes...
;; or maybe put the prefixed symbols in the help table, too

;; for this test, Ι just use the prefixed symbols...

;; could a hash map or trie be better? How many symbols do I need to have
;; documentation for? With wikidata and more this could easily be several
;; thousand... Do I really want to hold them inside emacs, or do I need to hold
;; them in some tool and if nessecary regenerate them? 
(setq triplestore-mode--eldoc-obarray (make-vector 41 0))

(set (intern "gist:hasParty" triplestore-mode--eldoc-obarray)
     "subPropertyOf: gist:hasParticipant\n
prefLabel: \"has party\"\n
range: unionOf (gist:Organisation gist:Person)\n
Definition: The people or organizations participating in an event, agreement or obligation\n
Example: For loan agreements, one might create hasLender and hasBorrower as subproperties of hasParty.")

;; it would be nice to also show the class of an entity, e.g. the gist:Party mentioned here,
;; but that would mean reason over the whole file...
(set (intern "hasCommunicationAddress" triplestore-mode--eldoc-obarray)
     "subPropertyOf: gist:hasAddress
prefLabel: \"has communication address\"
domain: unionOf (gist:Organisation gist:Person)
range: gist:Address
Definition: Relates a Person or Organization to where they can receive messages, 
  including postal addresses, fax numbers, phone numbers, email, web site, etc.")

(set (intern "gist:hasAddress" triplestore-mode--eldoc-obarray)
     "prefLabel: \"has address\"
range: gist:Address
Definition: Relates the subject to its physical or virtual address.
Example: The street address of a building; the email address of a person.")

(set (intern "gist:hasUnitOfMeasure" triplestore-mode--eldoc-obarray)
     "prefLabel: \"has unit of measure\"
domain: gist:Magnitude
range: gist:UnitOfMeasure
Definition: Which unit of measure you are using. All measures are expressed in some unit of measure, even if we don't know what it is initially.")

(defun triplestore-mode--eldoc-function (callback &rest _ignored)
  "Returns documentation for predicates and classes from RDFS, OWL or SHACL definitions."
  ;; need to get the IRI here, i.e. if it's an IRI, take that, if not, make the
  ;; IRI from prefix and rest
  (when-let ((docstring  (symbol-value
                          (intern-soft (thing-at-point 'symbol)
                                       triplestore-mode--eldoc-obarray))))
    
    (funcall callback
             (format "%s" docstring)
             :thing 'what
             :face 'font-lock-doc-face)
    nil))



;;; end eldoc

;;;###autoload
(define-minor-mode triplestore-mode
  "Working with RDF and Triplestore: Documentation (and in the future: completition, connections, query and updates)."
  :interactive '(ttl-mode sparql-mode omn-mode owl-functional-mode)
  (if triplestore-mode
      (add-hook 'eldoc-documentation-functions #'triplestore-mode--eldoc-function nil t)
    (remove-hook 'eldoc-documentation-functions #'triplestore-mode--eldoc-function t)))

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
