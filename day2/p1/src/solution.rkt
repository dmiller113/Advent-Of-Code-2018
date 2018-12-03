#lang racket

(define test1 "abcdef")
(define test2 "bababc")
(define test3 "abbcde")
(define test4 "abcccd")
(define test5 "aabcdd")
(define test6 "abcdee")
(define test7 "ababab")
(define test-list (list
  test1
  test2
  test3
  test4
  test5
  test6
  test7))

(define path "../../data/boxes")
(define input
  (open-input-file path #:mode 'text))
(define input-lines
  (port->lines input))

(define pair->list (lambda
  [c] (let
    ([x (car c)]
     [xs (cdr c)])
    (list x xs))))

(define handle-letter (lambda
    [letter acc] (let
      ([count (hash-ref acc letter 0)])
      (hash-set
        acc
        letter
        (+ count 1)))))

(define handle-word (lambda
  [word] (let*
    ([word-list (string->list word)]
     [char-hash (foldl
        handle-letter
        (hash)
        word-list)])
    (foldl
      (lambda
        [key-value counts]
        (let
          ([value (cdr key-value)]
           [two? (car counts)]
           [three? (cdr counts)])
          (cons
            (or
              two?
              (= value 2))
            (or
              three?
              (= value 3)))))
    (cons false false)
    (hash->list char-hash)))))

(define checksum (lambda
  [word-list]
  (foldl * 1 (pair->list (foldl
    (lambda
      [word acc]
      (let*
        ([count (handle-word word)]
         [two? (car count)]
         [three? (cdr count)]
         [twos (car acc)]
         [threes (cdr acc)])
        (cons
          (+
            twos
            (if two? 1 0))
          (+
            threes
            (if three? 1 0)))))
    (cons 0 0)
    word-list)))))


(printf "1: ~a\n" (handle-word test1))
(printf "2: ~a\n" (handle-word test2))
(printf "3: ~a\n" (handle-word test3))
(printf "4: ~a\n" (handle-word test4))
(printf "5: ~a\n" (handle-word test5))
(printf "6: ~a\n" (handle-word test6))
(printf "7: ~a\n" (handle-word test7))
(printf "L: ~a\n" (checksum test-list))
(printf "f: ~a\n" (checksum input-lines))
(close-input-port input)
