#lang racket

(provide word->regex lift2 ap test-list)

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
  (foldl
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

;; (lift2 regexp-match (map word->regex test-list) test-list)
