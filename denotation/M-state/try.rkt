#lang racket

(provide M-state-try)

(require "../../functional/either.rkt")
(require "../../language/symbol/operator/try.rkt")

(define (M-state-try M-state
                     args
                     state
                     throw
                     return
                     continue)
  (try (M-state (try-body args)
                state
                throw
                return
                continue)
       (lambda (state)
         (if (try-has-finally? args)
             (M-state (try-finally args)
                      state
                      throw
                      return
                      continue)
             (success state)))))