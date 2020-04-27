#lang racket

(provide M-state-class-declare)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../machine/machine-scope.rkt"
         "../M-value.rkt"
         "../closure.rkt")

(define (M-state-class-declare M-state
                                  args
                                  state
                                  throw
                                  return
                                  continue
                                  break)
  (let ([name (first-argument args)])
    (if (machine-bound-top? state name)
        (failure (format "redefining: ~a" name))
        (success (machine-bind-new state
                                   name
                                   (closure (second-argument args)
                                            (third-argument args)
                                            (machine-level state)))))))