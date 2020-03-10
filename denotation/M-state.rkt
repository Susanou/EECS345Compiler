#lang racket

(provide M-state)

(require "../functional/either.rkt"
         "../language/expression.rkt"
         "../language/symbol/operator/control.rkt"
         "../language/symbol/operator/variable.rkt"
         "../language/symbol/operator/block.rkt"
         "../language/symbol/operator/int.rkt"
         "M-state/return.rkt"
         "M-state/declare.rkt"
         "M-state/assign.rkt"
         "M-state/if.rkt"
         "M-state/while.rkt"
         "M-state/continue.rkt"
         "M-state/block.rkt"
         "M-state/begin.rkt"
         "M-state/binary-arithmatic.rkt")

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
      (operate (operator  exp)
               (arguments exp)
               state
               return
               continue)
      (success state)))

(define (operate op
                 args
                 state
                 return
                 continue)
  ((hash-ref operations
             op
             (thunk*failure "unrecognized operation")) M-state
                                                       args
                                                       state
                                                       return
                                                       continue))

(define operations
  (hash
   RETURN   M-state-return
   DECLARE  M-state-declare
   ASSIGN   M-state-assign
   CONTINUE M-state-continue
   IF       M-state-if
   WHILE    M-state-while
   BLOCK    M-state-block
   BEGIN    M-state-begin
   ADDITION M-state-binary-arithmatic))