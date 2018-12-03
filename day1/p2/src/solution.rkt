#lang racket

(define frequency-set (set 0))
(define test-list1 '(1 -1))
(define test-list2 '(3 3 4 -2 -4))
(define test-list3 '(-6 3 8 5 -6))
(define test-list4 '(7 7 -2 -7 -4))
(define input-list (map
	string->number (port->lines
		(open-input-file
			"../data/frequencies" #:mode 'text))))


(define find-repeat (case-lambda
	[(matched-frequency) matched-frequency]
  [(frequencies matched-frequencies) (find-repeat
		frequencies 0 matched-frequencies frequencies)]
	[(frequencies 
		total-frequency matched-frequencies initial) (if (empty?
		frequencies) (find-repeat
			initial total-frequency matched-frequencies initial) (let*
			([head (car frequencies)]
			 [tail (cdr frequencies)]
			 [new-total (+ total-frequency head)]
			 [in-set? (set-member?
				matched-frequencies new-total)]
			 [new-set (set-add matched-frequencies new-total)])
			 (if in-set?
				(find-repeat new-total)
				(find-repeat tail new-total new-set initial))))]))

(printf "~a\n" (find-repeat test-list1 frequency-set))
(printf "~a\n" (find-repeat test-list2 frequency-set))
(printf "~a\n" (find-repeat test-list3 frequency-set))
(printf "~a\n" (find-repeat test-list4 frequency-set))
(printf "~a\n" (find-repeat input-list frequency-set))
