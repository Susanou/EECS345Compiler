#lang racket

(provide M-int)

(require "mapping.rkt"
         "../machine/binding.rkt"
         "../machine/machine-scope.rkt")

(define (M-int expression state)
  (mapping-value (hash-ref (hash
                            '(+ 1 2)                          3
                            '(- (/ (* 6 (+ 8 (% 5 3))) 11) 9) -4
                            '(+ (* 6 (- (* 4 2))) 9)          -39
                            '(/ (- (* 5 7) 3) 2)              16)
                           expression
                           (cond [(integer? expression) expression]
                                 [(symbol?  expression)
                                  (binding-value (machine-scope-ref state
                                                                    expression))]
                                 [else 0]))))
