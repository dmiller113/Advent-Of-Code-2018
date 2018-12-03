#lang racket

(define path "../data/frequencies")
(define input (open-input-file path #:mode 'text))
(define input-lines (port->lines input))

(printf "~a" (foldl
	+ 0 (map
		string->number input-lines)))
