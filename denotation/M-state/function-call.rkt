#lang racket

(provide M-state-function-call)

(require "../../functional/either.rkt"
         "../call.rkt"
         "../M-value.rkt")

(define (M-state-function-call M-state
                               args
                               state
                               throw
                               return
                               continue
                               break)  
  (call M-state
        M-value
        args
        state
        throw
        (lambda (value state) (success state))
        (lambda (      state) (success state))))