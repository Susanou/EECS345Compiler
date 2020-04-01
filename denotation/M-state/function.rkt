#lang racket

(provide M-state-function)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../machine/machine-scope.rkt"
         "../M-value.rkt")

(define (M-state-function    M-state
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