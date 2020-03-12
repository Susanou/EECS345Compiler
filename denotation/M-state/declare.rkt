#lang racket

(provide M-state-declare)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../machine/machine-scope.rkt"
         "../M-value.rkt")

(define (M-state-declare M-state
                         args
                         state
                         return
                         continue)
  (let ([name (left-argument  args)])
    (if (machine-bound-top? state name)
        (failure (format "redefining: ~a" name))
        (if (binary-argument? args)
            (try (M-value (right-argument args) state M-state)
                 (lambda (init)
                   (success (machine-bind-new state
                                              name
                                              init))))
            (success (machine-bind-new state
                                       name
                                       null))))))