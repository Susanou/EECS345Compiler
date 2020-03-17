#lang racket

(provide M-state-block)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../language/symbol/operator/block.rkt")

(define (M-state-block M-state
                       args
                       state
                       throw
                       return
                       continue)
  (if (null? args)
      (success state)
      (try (M-state (first args)
                    state
                    throw
                    return
                    continue)
           (lambda (state)
             (M-state (single-expression BLOCK (rest args))
                      state
                      throw
                      return
                      continue)))))