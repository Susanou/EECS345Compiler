#lang racket

(provide M-bool)

(require  "mapping.rkt"
          "M-int.rkt"
          "mapping-utilities.rkt")

(define (M-bool expression state)
  (cond
    [(lang-boolean?    expression) (constant-mapping-value   expression)]
    [(lang-variable?   expression) (map-variable 'BOOL       expression state)]
    [(lang-expression? expression) (map-operation operations expression state)]
    [else                          (mapping-error "unsupported")]))

(define constants
  (hash 'true #t
        'false #f))

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
   '=  (unary-operation-right-hand values M-bool)

   '!  (unary-operation  not  M-bool       )
   '&& (binary-operation andb M-bool M-bool)
   '|| (binary-operation orb  M-bool M-bool)
   
   '== (binary-operation =    M-int  M-int )
   '!= (binary-operation !=   M-int  M-int ) 
   '>= (binary-operation >=   M-int  M-int )
   '<= (binary-operation <=   M-int  M-int )
   '>  (binary-operation >    M-int  M-int )
   '<  (binary-operation <    M-int  M-int )))