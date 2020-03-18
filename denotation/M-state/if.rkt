#lang racket

(provide M-state-if)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../M-bool.rkt")

(define (M-state-if M-state
                    args
                    state
                    throw
                    return
                    continue
                    break)
  (let ([condition-arg (first-argument args)])
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
                      (M-state (second-argument args)
                               state
                               throw
                               return
                               continue
                               break)
                      (if (triady-argument? args)
                          (M-state (third-argument args)
                                   state
                                   throw
                                   return
                                   continue
                                   break)
                          (success state)))))))))