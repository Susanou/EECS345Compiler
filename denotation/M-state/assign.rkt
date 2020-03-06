#lang racket

(provide M-state-assign)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../machine/machine-scope.rkt"
         "../M-value.rkt")

(define (M-state-assign args state return continue)
  (let ([name  (left-argument  args)])
    (if (machine-bound-any? state name)
        (try (M-value (right-argument args) state)
             (lambda (value)
               (success (machine-bind-current state
                                              name
                                              value))))
        (failure (format "assign before declare: ~s"
                         name)))))