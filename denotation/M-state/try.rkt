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
  (try (let/cc c
         (M-state (try-body args)
                  state
                  (lambda (case state)
                    (c (if (try-has-catch? args)
                           (M-state (try-catch args)
                                    state
                                    throw
                                    return
                                    continue)
                           (success state))))
                  (lambda (value state)
                    (try (if (try-has-finally? args)
                             (M-state (try-finally args)
                                      state
                                      throw
                                      return
                                      continue)
                             (success state))
                         (lambda (state)
                           (return value state))))
                  (lambda (state)
                    (try (if (try-has-finally? args)
                             (M-state (try-finally args)
                                      state
                                      throw
                                      return
                                      continue)
                             (success state))
                         continue))))
       (lambda (state)
         (if (try-has-finally? args)
             (M-state (try-finally args)
                      state
                      throw
                      return
                      continue)
             (success state)))))