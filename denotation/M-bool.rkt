#lang racket

(provide M-bool)

(require  "mapping.rkt"
          "M-int.rkt"
          "mapping-utilities.rkt"
          "language.rkt")

(define (M-bool exp state)
  (cond
    [(BOOL? exp) (constant-mapping-value   exp        )]
    [(VAR?  exp) (map-variable 'BOOL       exp state  )]
    [(EXP?  exp) (map-operation operations exp state  )]
    [else        (mapping-error "not mappable to BOOL")]))

(define constants
  (hash TRUE #t
        FALSE #f))

(define (constant-mapping-value expression)
  (mapping-value (hash-ref constants expression)))

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
   OP-ASSIGN (unary-operation  values args-right M-bool)
   OP-NOT    (unary-operation  not    args-left  M-bool       )
   OP-AND    (binary-operation andb              M-bool M-bool)
   OP-OR     (binary-operation orb               M-bool M-bool)
   OP-EQ     (binary-operation =                 M-int  M-int )
   OP-NEQ    (binary-operation !=                M-int  M-int ) 
   OP-LTE    (binary-operation <=                M-int  M-int )
   OP-GTE    (binary-operation >=                M-int  M-int )
   OP-LT     (binary-operation <                 M-int  M-int )
   OP-GT     (binary-operation >                 M-int  M-int )))