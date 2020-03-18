#lang racket

(provide M-state-begin)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../language/symbol/operator/block.rkt"
         "../../machine/machine-scope.rkt")

(define (pass-value cont)
  (lambda (value scope)
    (cont value
          (machine-scope-pop scope))))

(define (pass-state cont)
  (lambda (state)
    (cont (machine-scope-pop state))))

(define (M-state-begin M-state
                       args
                       state
                       throw
                       return
                       continue
                       break)
  (try (M-state (single-expression BLOCK args)
                (machine-scope-push state    )
                (pass-value throw            )
                (pass-value return           )
                (pass-state continue         )
                (pass-state break            ))
       (lambda (state)
         (success (machine-scope-pop state)))))