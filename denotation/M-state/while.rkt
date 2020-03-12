#lang racket

(provide M-state-while)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../language/symbol/operator/control.rkt"
         "../M-bool.rkt")

(define (M-state-while M-state
                       args
                       state
                       return
                       continue)
  (try (M-bool (left-argument args) state M-state)
       (lambda (condition)
         (if condition
             (try (let/cc c
                    (M-state (right-argument args)
                             state
                             return
                             (lambda (state)
                               (c (success state)))))
                  (lambda (state)
                    (M-state (single-expression WHILE args)
                             state
                             return
                             continue)))
             (success state)))))