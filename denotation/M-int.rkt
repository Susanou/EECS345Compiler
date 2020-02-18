#lang racket

(provide M-int)

(require "mapping.rkt"
         "mapping-utilities.rkt"
         "language.rkt")

(define (M-int exp state)
  (cond [(INT? exp) (mapping-value            exp       )]
        [(VAR? exp) (map-variable 'INT        exp state )]
        [(EXP? exp) (map-operation operations exp state )]
        [else       (mapping-error "not mappable to INT")]))

(define operations
  (hash OP-ASSIGN (unary-operation-right-hand values         M-int      )
        OP-ADD    (binary-operation +                        M-int M-int)
        OP-SUB    (unary-binary-operator (unary-operation  - M-int      )
                                         (binary-operation - M-int M-int))
        OP-MUL    (binary-operation *                        M-int M-int)
        OP-DIV    (binary-operation quotient                 M-int M-int)
        OP-MOD    (binary-operation remainder                M-int M-int)))
