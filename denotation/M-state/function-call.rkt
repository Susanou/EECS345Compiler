#lang racket

(provide M-state-function-call)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../machine/machine-scope.rkt"
         "../M-value.rkt")

(define (M-state-function-call M-state
                               args
                               state
                               throw
                               return
                               continue
                               break)
  (success state))