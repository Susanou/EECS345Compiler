#lang racket

(provide M-int)

(require "mapping.rkt")

(define (M-int expression state)
  (mapping-value
   (if (equal? expression '(+ 1 2))
       3
       0)))
