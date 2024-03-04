;; ParserSpring24
;;Derrick Jennings II
;; 12166134
;;CS 441
;;03/03/24

#lang racket
(require megaparsack)
(require megaparsack/text)
(require data/monad)
(require data/applicative)

(define program/p
   (do (linelist/p)
     (endoffile/p)
     (pure "Accept")))
  
(define linelist/p
  (or/p (try/p (do (line/p) (linelist/p)))
               (epsilon/p)))
(define line/p
  (do (labels/p)
    (stmt/p)
    (linetail/p)))
(define labels/p
  (or/p (try/p (do (id/p) (char/p #\:)))
        (epsilon/p)))
(define linetail/p
  (or/p (try/p (do (char/p #\;) (stmt/p) (char/p #\+)))
        (epsilon/p)))
(define stmt/p
  (or/p (try/p (do (id/p) (char/p #\=) (expr/p)))
        (try/p (do (if/p) (char/p #\() (boolean/p) (char/p #\)) (stmt/p))) ;keyword
        (try/p (do (while/p) (char/p #\() (boolean/p) (char/p #\)) (linelist/p) (endwhile/p))) ;keyword
        (try/p (do (read/p) (id/p))) ;keyword
        (try/p (do (write/p) (expr/p))) ;keyword
        (try/p (do (goto/p) (id/p))) ;keyword
        (try/p (do (gosub/p) (id/p))) ;keyword
        (try/p (return/p)) ;keyword
        (try/p (break/p)) ;keyword
        (end/p)));keyword
(define boolean/p
  (or/p (try/p (true/p))
        (try/p (false/p))
        (do (expr/p) (bool-op/p) (expr/p))))

(define bool-op/p
  (or/p (try/p (char/p #\<))
        (try/p (char/p #\>))
        (try/p (char-in/p ">=")) ;char-in for many
        (try/p (char-in/p "<=")) ;char-in for many
        (try/p (char-in/p "<>")) ;char-in for many
        (char-in/p "=")))

(define expr/p
  (or/p (try/p (do (id/p) (etail/p)))
        (try/p (do (num/p) (etail/p)))
        (do (char/p #\() (expr/p) (char/p #\)))))
(define etail/p
  (or/p (try/p (do (char/p #\+) (expr/p)))
        (try/p (do (char/p #\-) (expr/p)))
        (try/p (do (char/p #\*) (expr/p)))
        (try/p (do (char/p #\/) (expr/p)))
        (epsilon/p)))

(define num/p
  (do (numsign/p)
    (many/p satisfy/p char-numeric?))) ; dont know if this will stop at end of string or keep going
(define numsign/p
  (or/p (try/p (char/p #\+))
        (try/p (char-/p #\-))
        (epsilon/p)))

    
        

        
               


(define (char-letter-or-digit? char)
  (or (char-alphabetic? char) (char-numeric? char)))
(define letters-or-digits/p
  (satisfy/p char-letter-or-digit?))

(define (not-letter-or-digit? char)
  (not (or (char-alphabetic? char) (char-numeric? char))))
    
(define id/p
  (do (satisfy/p char-alphabetic?)
    (many/p letters-or-digits/p)
    (eof/p))))


(define (parse file-path)
  (let ((file-contents (file->string file-path)))
    (parse-result!(parse-string file-contents))))

  
(parse-result! (parse-string id/p "cb1"))
