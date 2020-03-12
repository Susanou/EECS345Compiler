#lang racket

(provide M-bool)

(require  "../functional/either.rkt"
          "../language/expression.rkt"
          "../language/symbol/variable.rkt"
          "../language/symbol/literal/bool.rkt"
          "../language/symbol/operator/bool.rkt"
          "../language/symbol/operator/variable.rkt"
          "../language/symbol/operator/comparison.rkt"
          "util.rkt"
          "M-int.rkt")

(define literals
  (hash TRUE  #t
        FALSE #f))

(define (literal exp)
  (success (hash-ref literals exp)))

(define (M-bool exp state M-state)
  (cond
    [(BOOL?       exp) (literal                  exp              )]
    [(VARIABLE?   exp) (map-variable 'BOOL       exp state        )]
    [(EXPRESSION? exp) (map-operation operations exp state M-state)]
    [else              (failure "not mappable to BOOL"            )]))

(define (2and a b)
  (and        a b))

(define (2or a b)
  (or        a b))

(define (!= a b)
  (not (=   a b)))

(define operations
  (hash
   ASSIGN           (unary-operation  values right-argument M-bool)
   NOT              (unary-operation  not    left-argument  M-bool)
   AND              (binary-operation 2and                  M-bool M-bool)
   OR               (binary-operation 2or                   M-bool M-bool)
   EQUAL            (binary-operation =                     M-int  M-int)
   NOT-EQUAL        (binary-operation !=                    M-int  M-int) 
   LESS-OR-EQUAL    (binary-operation <=                    M-int  M-int)
   GREATER-OR-EQUAL (binary-operation >=                    M-int  M-int)
   LESS             (binary-operation <                     M-int  M-int)
   GREATER          (binary-operation >                     M-int  M-int)))