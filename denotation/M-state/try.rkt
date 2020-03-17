#lang racket

(provide M-state-try)

(require "../../functional/either.rkt")
(require "../../language/try.rkt")
(require "../../machine/machine-scope.rkt")

(define (bind-in-begin cause-name cause-value state)
  (machine-bind-new (machine-scope-push state)
                    cause-name
                    cause-value))

(define (M-state-try M-state
                     args
                     state
                     throw
                     return
                     continue)
  (try (let/cc c
         (M-state (try-body args)
                  state
                  (lambda (cause state)
                    (c (if (try-has-catch? args)
                           (M-state (try-catch-body args)
                                    (bind-in-begin (try-catch-bind args)
                                                   cause
                                                   state)
                                    throw
                                    (lambda (value state)
                                      (let ([state (machine-scope-pop state)])
                                        (try (if (try-has-finally? args)
                                                 (M-state (try-finally args)
                                                          state
                                                          throw
                                                          return
                                                          continue)
                                                 (success state))
                                             (lambda (state)
                                               (return value state)))))
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