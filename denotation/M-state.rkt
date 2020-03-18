#lang racket

(provide M-state)

(require "../functional/either.rkt"
         "../language/expression.rkt"
         "../language/symbol/operator/control.rkt"
         "../language/symbol/operator/variable.rkt"
         "../language/symbol/operator/block.rkt"
         "../language/symbol/operator/int.rkt"
         "../language/symbol/operator/bool.rkt"
         "../language/symbol/operator/comparison.rkt"
         "M-state/return.rkt"
         "M-state/declare.rkt"
         "M-state/assign.rkt"
         "M-state/if.rkt"
         "M-state/while.rkt"
         "M-state/continue.rkt"
         "M-state/block.rkt"
         "M-state/begin.rkt"
         "M-state/try.rkt"
         "M-state/throw.rkt"
         "M-state/unary-arithmatic.rkt"
         "M-state/binary-arithmatic.rkt"
         "M-state/unary-or-binary-arithmatic.rkt")

(define (thunk*failure message)
  (thunk* (failure message)))

(define no-return
  (thunk*failure "unexpected return"))

(define no-continue
  (thunk*failure "continue outside loop"))

(define (uncaught-throw cause state)
  (failure (format "uncaught exception: ~a"
                   cause)))

(define (M-state
         exp
         state
         (throw    uncaught-throw)
         (return   no-return     )
         (continue no-continue   ))
  (if (EXPRESSION? exp)
      (operate (operator  exp)
               (arguments exp)
               state
               throw
               return
               continue)
      (success state)))

(define unrecognized-op
  (thunk (thunk*failure "unrecognized operation")))

(define (operate op
                 args
                 state
                 throw
                 return
                 continue)
  ((hash-ref operations
             op
             unrecognized-op) M-state
                              args
                              state
                              throw
                              return
                              continue))

(define operations
  (hash
   RETURN           M-state-return
   DECLARE          M-state-declare
   ASSIGN           M-state-assign
   CONTINUE         M-state-continue
   TRY              M-state-try
   THROW            M-state-throw
   IF               M-state-if
   WHILE            M-state-while
   BLOCK            M-state-block
   BEGIN            M-state-begin
   ADDITION         M-state-binary-arithmatic
   MULTIPLICATION   M-state-binary-arithmatic
   MODULO           M-state-binary-arithmatic
   DIVISION         M-state-binary-arithmatic
   SUBTRACTION      M-state-unary-or-binary-arithmatic
   OR               M-state-binary-arithmatic
   AND              M-state-binary-arithmatic
   NOT              M-state-unary-arithmatic
   EQUAL            M-state-binary-arithmatic
   NOT-EQUAL        M-state-binary-arithmatic
   LESS-OR-EQUAL    M-state-binary-arithmatic
   GREATER-OR-EQUAL M-state-binary-arithmatic
   LESS             M-state-binary-arithmatic
   GREATER          M-state-binary-arithmatic))