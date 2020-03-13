#lang racket

(provide M-state-if)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../M-bool.rkt")

(define (M-state-if M-state
                    args
                    state
                    return
                    continue)
  (let ([condition-arg (first-argument args)])
    (try (M-bool condition-arg state M-state)
         (lambda (condition)
           (try (M-state condition-arg state)
                (lambda (state)
                  (if condition
                      (M-state (second-argument args)
                               state
                               return
                               continue)
                      (if (triady-argument? args)
                          (M-state (third-argument args)
                                   state
                                   return
                                   continue)
                          (success state)))))))))