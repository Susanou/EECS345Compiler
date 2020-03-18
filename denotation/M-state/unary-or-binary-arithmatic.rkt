#lang racket

(provide M-state-unary-or-binary-arithmatic)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "unary-arithmatic.rkt"
         "binary-arithmatic.rkt")

(define illegal-argument-count
  (thunk* (failure "not single or binary argument")))

(define (handler args)
  (cond [(single-argument? args) M-state-unary-arithmatic ]
        [(binary-argument? args) M-state-binary-arithmatic]
        [else                    illegal-argument-count   ]))

(define (M-state-unary-or-binary-arithmatic M-state
                                            args
                                            state
                                            throw
                                            return
                                            continue
                                            break)
  ((handler args) M-state
                  args
                  state
                  throw
                  return
                  continue
                  break))