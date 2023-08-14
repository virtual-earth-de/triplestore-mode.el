;; input file
(setq inputFile "ids-uniq.txt")

;; other vars
(setq moreLines t ) ;; whether there are more lines to parse
(require 'trie)
(setq id-trie (make-trie '<))
(setq myLine "")
(setq listLine nil)

;; open the file
(with-temp-buffer
  (insert-file-contents inputFile)

  (goto-char (point-min)) ;; needed in case the file is already open.


  (while moreLines

    (let* ((myLine (buffer-substring-no-properties
                    (line-beginning-position)
                    (line-end-position)))
           (listLine (string-split myLine "/")))

      (trie-insert id-trie myLine (nth (- (length listLine) 2) listLine))
      (setq moreLines (= 0 (forward-line 1))))))

(setq testS (string-split "http://data.linkedmdb.org/resource/writer/996" "/"))
(nth (- (length testS) 2) testS)
(trie-complete id-trie "http://data.linkedmdb.org/resource/w")
(trie-lookup id-trie "http://data.linkedmdb.org/resource/writer/996")

;; 
