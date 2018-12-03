#lang racket

(define path "../data/frequencies")
(define input (open-input-file path #:mode 'text))
(define input-lines (port->lines input))
(define sum (lambda
	(a b) (+ a b)))

(printf "~a" (foldl
	sum 0 (map
		string->number input-lines)))
