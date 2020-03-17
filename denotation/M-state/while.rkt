#lang racket

(provide M-state-while)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../language/symbol/operator/control.rkt"
         "../M-bool.rkt")

(define (M-state-while M-state
                       args
                       state
                       throw
                       return
                       continue)
  (let ([condition-arg (left-argument args)])
    (try (M-bool condition-arg
                 state
                 M-state
                 throw)
         (lambda (condition)
           (try (M-state condition-arg
                         state
                         throw)
                (lambda (state)
                  (if condition
                      (try (let/cc c
                             (M-state (right-argument args)
                                      state
                                      throw
                                      return
                                      (lambda (state)
                                        (c (success state)))))
                           (lambda (state)
                             (M-state (single-expression WHILE args)
                                      state
                                      throw
                                      return
                                      continue)))
                      (success state))))))))