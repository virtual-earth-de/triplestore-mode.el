;;; triplestore-connection.el --- endpoint handling for different triple stores -*- lexical-binding: t; -*-

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

;; This package handles connections to triplestores 

;;;; Installation

;;;;; MELPA

;; If you installed from MELPA you need to add TREP to all the modes you want to use it, e.g.:

;; (add-hook 'ttl-mode-hook (lambda () (setq-local sesman-system 'TREP)))
;; (add-hook 'omn-mode-hook (lambda () (setq-local sesman-system 'TREP)))
;; (add-hook 'owl-functional-mode-hook (lambda () (setq-local sesman-system 'TREP)))

;;;;; use-package

;; This should work with MELPA, straight, and possibly other systems that support use-package
;; (use-package triplestore-connection
;; :hook (ttl-mode omn-mode owl-functional-mode) . (lambda () (setq sesman-system 'TREP)))

;;;; Usage

;; Run one of these commands:

;; `triplestore-endpoint-connect': connect to sparql endpoint. Will ask for connection name and endpoint URL

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
(require 'sesman)

;; session setup starts here
(setq sesman-system 'TREP)

(cl-defmethod sesman-start-session ((system (eql TREP)))
  (let ((name (gensym "TREP-")))
    (sesman-register 'TREP (list (symbol-name name) "TREP-Config-1" (gensym "TREP-config-1-")))))


(cl-defmethod sesman-quit-session ((system (eql TREP)) session)
  (setcdr session '("TREP killed]")))

;; I want to have a plist in my session-config, and to edit it I will get it out,
;; work on it with plist-* and then replace it in the session
(defun set-session-objects (system session-name &rest session-config)
  "Replace everything in session SESSION-NAME with SESSION-CONFIG"
  (let ((session (sesman-session system session-name))
        (new-session (cons session-name session-config)))
    (unless session (error "No session named %s found" session-name))
    (puthash (cons system (car session)) new-session sesman-sessions-hashmap)))

;; add TREP as sesman system to ttl and owl modes 
;; TODO: make this configurable or remove it and put it in installation instructions!

;; generic api starts here

(cl-defgeneric triplestore-endpoint--connect (triplestore-type  endpoint-url :username username :password password)
  "This connects to a triplestore and stores the connection via sesman.
A Sparql 'connection' is a virtual thing, it's actually just a REST endpoint.
Basically, it's an alist with connection properties like URL and auth info."

  (let ((session (sessman-start)))

    ))

(defun triplestore-endpoint--blazegraph? (endpoint-url)
  (let ((status ())))
  )

(defun triplestore-endpoint--identify (endpoint-url)
  "Identify type of triplestore at URL, return iditifying keyword."


  )

(cl-defgeneric triplestore-endpoint-config (type endpoint-url)
  "Identify config for triplestore of TYPE at ENDPOINT-URL, return config plist.")
(cl-defmethod ((eq :blazegraph) endpoint-url)

  )



;; configure UI
(define-key triplestore-mode-map (kbd "C-c C-s" 'sesman-map))
(sesman-install-menu triplestore-mode-map)

;;; triplestore-mode.el ends here
