#lang racket

(provide M-state-unary-arithmatic)

(require "../../functional/either.rkt"
         "../../language/expression.rkt")

(define (M-state-unary-arithmatic M-state
                                  args
                                  state
                                  return
                                  continue)
  (try (M-state (single-argument args) state)
       success))