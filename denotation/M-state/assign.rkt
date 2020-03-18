#lang racket

(provide M-state-assign)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../machine/machine-scope.rkt"
         "../M-value.rkt")

(define (M-state-assign M-state
                        args
                        state
                        throw
                        return
                        continue
                        break)
  (let ([name  (left-argument  args)])
    (if (machine-bound-any? state name)
        (try (M-value (right-argument args)
                      state
                      M-state
                      throw)
             (lambda (value)
               (try (M-state (right-argument args)
                             state
                             throw)
                    (lambda (state)
                      (success (machine-bind-current state
                                                     name
                                                     value))))))
        (failure (format "assign before declare: ~s"
                         name)))))