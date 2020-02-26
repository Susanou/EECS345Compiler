#lang racket

(provide M-bool)

(require  "../functional/either.rkt"
          "M-int.rkt"
          "mapping-utilities.rkt"
          "../language/symbol/literal/bool.rkt"
          "../language/symbol/variable.rkt"
          "../language/expression.rkt"
          "../language/symbol/operator/variable.rkt"
          "../language/symbol/operator/bool.rkt"
          "../language/symbol/operator/comparison.rkt")

(define (M-bool exp state)
  (cond
    [(BOOL? exp) (literal-mapping-value    exp        )]
    [(VARIABLE?  exp) (map-variable 'BOOL       exp state  )]
    [(EXPRESSION?  exp) (map-operation operations exp state  )]
    [else        (failure "not mappable to BOOL")]))

(define literals
  (hash TRUE  #t
        FALSE #f))

(define (literal-mapping-value expression)
  (success (hash-ref literals expression)))

; define binary and and or procedures: since
; (and ...) and (or ...) are both syntax, not procedures
; so they can't be passed around like variables

(define (andb a b)
  (and a b))

(define (orb a b)
  (or a b))

; define != procedure

(define (!= a b)
  (not (= a b)))

(define operations
  (hash
   VARIABLE-ASSIGN (unary-operation  values right-argument M-bool)
   BOOL-NOT    (unary-operation  not    left-argument  M-bool       )
   BOOL-AND    (binary-operation andb              M-bool M-bool)
   BOOL-OR     (binary-operation orb               M-bool M-bool)
   COMPARISON-EQUAL     (binary-operation =                 M-int  M-int )
   COMPARISON-NOT-EQUAL    (binary-operation !=                M-int  M-int ) 
   COMPARISON-LESS-THAN-OR-EQUAL    (binary-operation <=                M-int  M-int )
   COMPARISON-GREATER-THAN-OR-EQUAL    (binary-operation >=                M-int  M-int )
   COMPARISON-LESS-THAN     (binary-operation <                 M-int  M-int )
   COMPARISON-GREATER-THAN     (binary-operation >                 M-int  M-int )))