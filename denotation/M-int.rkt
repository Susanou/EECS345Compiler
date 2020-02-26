#lang racket

(provide M-int)

(require "../functional/either.rkt"
         "mapping-utilities.rkt"
         "../language/symbol/literal/int.rkt"
         "../language/symbol/variable.rkt"
         "../language/expression.rkt"
         "../language/symbol/operator/int.rkt"
         "../language/symbol/operator/variable.rkt")

(define (M-int exp state)
  (cond [(INT? exp) (success            exp       )]
        [(VARIABLE? exp) (map-variable 'INT        exp state )]
        [(EXPRESSION? exp) (map-operation operations exp state )]
        [else       (failure "not mappable to INT")]))

(define operations
  (hash VARIABLE-ASSIGN (unary-operation   values right-argument        M-int      )
        INT-ADDITION    (binary-operation  +                        M-int M-int)
        INT-SUBTRACTION    (unary-binary-operator
                            (unary-operation  -     left-argument          M-int      )
                            (binary-operation -                        M-int M-int))
        INT-MULTIPLICATION    (binary-operation  *                        M-int M-int)
        INT-DIVISION    (binary-operation  quotient                 M-int M-int)
        INT-MODULO    (binary-operation  remainder                M-int M-int)))
