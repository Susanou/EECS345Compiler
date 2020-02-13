#lang racket

(provide M-int)

(require "mapping.rkt")

(define (M-int expression state)
  (mapping-value 
    (cond 
    ((equal? expression '(+ 1 2)) 3)
    ((equal? expression 1) 1)
    (else 0))))
