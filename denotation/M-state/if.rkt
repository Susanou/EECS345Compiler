#lang racket

(provide M-state-if)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../M-bool.rkt")

(define (M-state-if M-state)
  (lambda (args state return continue)
    (try (M-bool (first-argument args) state)
         (lambda (condition)
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
                   (success state)))))))