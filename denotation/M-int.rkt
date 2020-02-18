#lang racket

(provide M-int)

(require "mapping.rkt"
         "../machine/binding.rkt"
         "../machine/machine-scope.rkt"
         "mapping-utilities.rkt")

(define (M-int expression state)
  (cond [(integer? expression) (mapping-value     expression)]
        [(symbol?  expression) (map-variable 'INT expression state)]
        [(list?    expression) (map-operation     expression state)]
        [else                  (mapping-error "unrecognized expression")]))

(define operations
  (hash '+ (binary-operation +                        M-int M-int)
        '- (unary-binary-operator (unary-operation  - M-int)
                                  (binary-operation - M-int M-int))
        '/ (binary-operation quotient                 M-int M-int)
        '% (binary-operation remainder                M-int M-int)
        '* (binary-operation *                        M-int M-int)))

(define (map-operation expression state)
  (let ([operator  (expression-operator expression)]
        [arguments (expression-arguments expression)])
    (if (hash-has-key? operations operator)
        ((hash-ref     operations operator) arguments state)
        (mapping-error "unrecognized operation"))))