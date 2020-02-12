#lang racket

(provide M-state)

(require "mapping.rkt"
         "../machine/machine-scope.rkt")

(define (M-state expression state)
  (cond [(equal? expression '(var x))
         (mapping-value (machine-scope-bind state
                                            'x
                                            null))]
        [(equal? expression '(= x 0))
         (mapping-value (machine-scope-bind state
                                            'x
                                            0))]
        [else
         (mapping-value state)]))
