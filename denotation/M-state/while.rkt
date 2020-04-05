#lang racket

(provide M-state-while)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../../language/symbol/operator/control.rkt"
         "../M-bool.rkt"
         "../M-value.rkt")

(define (M-state-while M-state
                       args
                       state
                       throw
                       return
                       continue
                       break)
  (let ([condition-arg (left-argument args)])
    (try (M-bool condition-arg
                 state
                 M-state
                 M-value
                 throw)
         (lambda (condition)
           (try (M-state condition-arg
                         state
                         throw)
                (lambda (state)
                  (if condition
                      (let/cc b
                        (try (let/cc c
                               (M-state (right-argument args)
                                        state
                                        throw
                                        return
                                        (lambda (state)
                                          (c (success state)))
                                        (lambda (state)
                                          (b (success state)))))
                             (lambda (state)
                               (M-state (single-expression WHILE args)
                                        state
                                        throw
                                        return
                                        continue
                                        break))))
                      (success state))))))))