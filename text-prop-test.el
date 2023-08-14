;;; text-prop-test.el -- testing text props

;;; Code:

;; In einem text-mode buffer ohne spellchecking testen, sonst überschreibt das spell-checking das underlining

(defun ve:mark-word (begin end fgcolor underline?)
  "Make current region from BEGIN to END colored in FGCOLOR and underlined if UNDERLINE?, using text properties."
  (interactive (let ((fgcolor (read-string "Farbe: " nil nil "red"))
                     (underline? (read-minibuffer "Underline this? " nil)))
                 (list (region-beginning) (region-end) fgcolor underline?)))
  ;;  (message "Coloring in %s, underlining? %S or %S" fgcolor underline? `(:underline ,underline? :foreground ,fgcolor))
  (add-text-properties begin end `(font-lock-face (:underline ,underline? :foreground ,fgcolor))))

;; falls es nicht angezeigt wird: die Properties kann man mit M-: checken,
;; indem man folgendes ausführt, mit dem cursor im markierten Text:
;; (get-text-property (region-beginning) 'font-lock-face)


(provide 'text-prop-test)
;;; text-prop-test.el ends here

