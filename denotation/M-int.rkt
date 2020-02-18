#lang racket

(provide M-int)

(require "mapping.rkt"
         "mapping-utilities.rkt")

(define (M-int expression state)
  (cond [(lang-integer?    expression) (mapping-value            expression)]
        [(lang-variable?   expression) (map-variable 'INT        expression state)]
        [(lang-expression? expression) (map-operation operations expression state)]
        [else                          (mapping-error "unrecognized expression")]))

(define operations
  (hash '= (unary-operation-right-hand values         M-int)
        '+ (binary-operation +                        M-int M-int)
        '- (unary-binary-operator (unary-operation  - M-int)
                                  (binary-operation - M-int M-int))
        '/ (binary-operation quotient                 M-int M-int)
        '% (binary-operation remainder                M-int M-int)
        '* (binary-operation *                        M-int M-int)))