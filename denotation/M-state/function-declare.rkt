#lang racket

(provide M-state-function-declare)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../machine/machine-scope.rkt"
         "../M-value.rkt")

(define (M-state-function-declare M-state
                                  args
                                  state
                                  throw
                                  return
                                  continue
                                  break)
  (let ([name (first args)])
    (if (machine-bound-top? state name)
        (failure (format "redefining: ~a" name))
        (success (machine-bind-new state
                                   name
                                   0)))))