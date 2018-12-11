#lang racket

(provide word->regex lift2 ap test-list regex-list input-match)

(define
  file-list
  (port->lines (open-input-file "../../data/boxes" #:mode 'text)))

(define
  no-false
  ((curry filter)
   (lambda
     (i)
     (not (eq? i false)))))


(define
  test-list
  '("abcde"
    "fghij"
    "klmno"
    "pqrst"
    "fguij"
    "axcye"
    "wvxyz"))

(define form-regex (lambda
  [word length]
  (lambda
    [idx]
    (let
      ([first-part (substring word 0 idx)]
       [last-part (substring word (+ 1 idx) length)])
      (string-append first-part "." last-part)))))

;; forall f. f (a -> b) -> f a -> f b
(define ap (lambda
  [bfn fx]
  (foldr
    (lambda
      [x acc]
        (append
          (map
            (lambda
              [fn]
              (fn x))
            bfn)
          acc))
      '()
      fx)))

;; forall f. (a -> b -> c) -> f a -> f b -> f c
(define lift2 (lambda
  [fn xs ys] (let
  ([cfn (curry fn)])
  (ap
    (map cfn xs)
    ys))))

(define word->regex (lambda
  [word]
  (let
    ([length (string-length word)])
    (map regexp
      (build-list
        length
        (form-regex word length))))))

(define regex-list (foldl
  (lambda
    (word acc)
    (list*
      (cons
	(word->regex word)
	word)
      acc))
  '()
  test-list))

(define regex-list2 (foldl
  (lambda
    (word acc)
    (list*
      (cons
	(word->regex word)
	word)
      acc))
  '()
  file-list))

(define match-word
  (lambda
    (item test-word)
    (let
      ([word (cdr item)]
       [regex (car item)])
      (if
	(eq? test-word word)
	false
	(foldl
	  (lambda
	    (reg acc)
	    (if
	      (regexp-match reg test-word)
	      word
	      acc))
	  false
	  regex)))))

(define
  common-letters
  (lambda
    (word1 word2)
    (let*
      ([letters1 (apply set (string->list word1))]
       [letters2 (apply set (string->list word2))])
      (apply string (set->list (set-intersect letters1 letters2))))))

(define test-match (no-false (lift2 match-word regex-list test-list)))

(define
  input-match
  (no-false (lift2 match-word regex-list2 file-list)))

(common-letters (car input-match) (cadr input-match))
(common-letters (car test-match) (cadr test-match))
