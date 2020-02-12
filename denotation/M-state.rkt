#lang racket

(provide M-state)

(require "mapping.rkt"
         "../machine/machine-scope.rkt")

(define (M-state expression state)
  (if (equal? expression '(var x))
      (mapping-value (machine-scope-bind state
                                         'x
                                         null))
      (mapping-value state)))
