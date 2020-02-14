#lang racket

(provide M-int)

(require "mapping.rkt")

(define (M-int expression state)
  (mapping-value (hash-ref (hash
                            '(+ 1 2)                          3
                            '(- (/ (* 6 (+ 8 (% 5 3))) 11) 9) -4
                            '(+ (* 6 (- (* 4 2))) 9)          -39)
                           expression
                           (if (integer? expression)
                               expression
                               0))))