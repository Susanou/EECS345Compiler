#lang racket

(provide M-state-begin)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../language/symbol/operator/block.rkt"
         "../../machine/machine-scope.rkt")

(define (M-state-begin M-state
                       args
                       state
                       throw
                       return
                       continue)
  (try (M-state (single-expression BLOCK args)
                (machine-scope-push state)
                throw
                (lambda (value state)
                  (return value
                          (machine-scope-pop state)))
                continue)
       (lambda (state)
         (success (machine-scope-pop state)))))