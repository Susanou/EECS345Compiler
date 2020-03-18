#lang racket

(provide M-state-throw)

(require "../../functional/either.rkt")
(require "../../language/expression.rkt")
(require "../M-value.rkt")

(define (M-state-throw M-state
                       args
                       state
                       throw
                       return
                       continue
                       break)
  (let ([exp (single-argument args)])
    (try (M-value exp
                  state
                  M-state
                  throw)
         (lambda (cause)
           (try (M-state exp
                         state)
                (lambda (state)
                  (throw cause state)))))))