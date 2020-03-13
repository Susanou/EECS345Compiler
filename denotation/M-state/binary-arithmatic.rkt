#lang racket

(provide M-state-binary-arithmatic)

(require "../../functional/either.rkt"
         "../../language/expression.rkt")

(define (M-state-binary-arithmatic M-state
                                   args
                                   state
                                   return
                                   continue)
  (try (M-state (first-argument args) state)
       (lambda (state)
         (try (M-state (second-argument args) state)
              success))))