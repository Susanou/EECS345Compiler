#lang racket

(provide M-state)

(require "../functional/either.rkt"
         "../language/expression.rkt"
         "../language/symbol/operator/control.rkt"
         "../language/symbol/operator/variable.rkt"
         "../language/symbol/operator/block.rkt"
         "M-state/return.rkt"
         "M-state/declare.rkt"
         "M-state/assign.rkt"
         "M-state/if.rkt"
         "M-state/while.rkt"
         "M-state/continue.rkt"
         "M-state/block.rkt"
         "M-state/begin.rkt")

(define (thunk*failure message)
  (thunk* (failure message)))

(define no-return
  (thunk*failure "unexpected return"))

(define no-continue
  (thunk*failure "continue outside loop"))

(define (M-state
         exp
         state
         (return no-return)
         (continue no-continue))
  (if (EXPRESSION? exp)
      (operation exp
                 state
                 return
                 continue)
      (success state)))

(define (operation exp state return continue)
  (let ([op (operator exp)])
    (if (hash-has-key? operations op)
        ((hash-ref     operations op) M-state
                                      (arguments exp)
                                      state
                                      return
                                      continue)
        (failure "unrecognized operation"))))

(define operations
  (hash
   RETURN   M-state-return
   DECLARE  M-state-declare
   ASSIGN   M-state-assign
   CONTINUE M-state-continue
   IF       M-state-if
   WHILE    M-state-while
   BLOCK    M-state-block
   BEGIN    M-state-begin))