;;; user.el --- scratch pad for experimenation

(require 'sesman)

(setq sesman-system 'TREP)

(cl-defmethod sesman-start-session ((system (eql TREP)))
  (let ((name (gensym "TREP-")))
    (sesman-register 'TREP (list (symbol-name name) "MakeThisToPlist" "TREP-Config-1" (gensym "TREP-config-1-")))))


(cl-defmethod sesman-quit-session ((system (eql TREP)) session)
  (setcdr session '("TREP killed]")))

(defun trep-sesman-set-session-objects (system session-name &rest session-config)
  "Replace all objects in SESSION-NAME with SESSION-CONFIG"
  (let ((session (sesman-session system session-name))
        (new-session (cons session-name session-config)))
    (unless session (error "No session named %s found" session-name))
    (puthash (cons system (car session)) new-session sesman-sessions-hashmap)))

;; Restart can stay with the default implementation; REST sessions should not have state

;; works
(let ((name (gensym "TREP-")))
  (type-of name))

(gensym "TREP-")
(sesman-sessions 'TREP)

(sesman-start)
(sesman-info)
(setq mysessions
      (sesman-sessions 'TREP))
mysessions
(assoc "TREP-807" mysessions)
(sesman-session 'TREP "TREP-808")
(sesman-current-session 'TREP)
(setq conn  '(:url "http://localhost:8080/sparql" :username "mathiasp" :password "Blubb938080/sparql" :type :graphdb))
(sesman-add-object 'TREP
                   (car (sesman-ask-for-session 'TREP "Which session" (sesman-sessions 'TREP) t))
                   '(:url "http://localhost:8080/sparql")
                   t)
(sesman-remove-object 'TERP
                      (car (sesman-ask-for-session 'TREP "Which session" (sesman-sessions 'TREP) t))
                      '(:url "http://localhost:8080/sparql")
                      ;; (:url "http://localhost:8080/sparql" :username "mathiasp" :password "Blubb938080/sparql" :type :blazegraph)
                      )
(assoc "TREP-808" (sesman-sessions 'TREP))
(sesman-get-session 'TREP "TREP-808")
(trep-sesman-set-session-objects 'TREP "TREP-808"  :test conn)

(sesman-quit)

(setq seq '("eins" :zwei ("drei")))
(cons "TERP-8080" '((:url "http://localhost:8080/sparql" :type :blazegraph :user "mathiasp" :password "blubb93") "dings"))
(delete  '("drei") seq)
seq
(list "trep" seq)

(setq trepr
      (request "http://localhost:8080/blazegraph/status"
        :parser 'buffer-string)
      )

trepr



;; user.el -- end of user.el
