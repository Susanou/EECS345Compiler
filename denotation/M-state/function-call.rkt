#lang racket

(provide M-state-function-call)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../language/symbol/operator/block.rkt"
         "../../machine/machine-scope.rkt"
         "../../language/type.rkt"
         "../M-value.rkt"
         "../util.rkt"
         "../closure.rkt")

(define (M-state-function-call M-state
                               args
                               state
                               throw
                               return
                               continue
                               break)
  (try (map-variable CLOSURE (first-argument args) state)
       (lambda (closure)
         (M-state (single-expression BLOCK (closure-body closure))
                  state
                  throw
                  return))))