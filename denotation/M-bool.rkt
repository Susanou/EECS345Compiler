#lang racket

(provide M-bool)

(require  "mapping.rkt"
          "M-int.rkt"
          "../machine/machine-scope.rkt"
          "../machine/binding.rkt"
          "mapping-utilities.rkt")

(define (M-bool expression state)
  (cond
    [(constant? expression) (constant-mapping-value  expression)]
    [(list?     expression) (operation-mapping-value expression state)]
    [(symbol?   expression) (map-variable 'BOOL      expression state)]
    [else                   (mapping-error "unsupported")]))

(define constants
  (hash 'true #t
        'false #f))

(define (constant? expression)
  (hash-has-key? constants expression))

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

(define (operation-mapping-value expression state)
  (if (hash-has-key? operations (car expression))
      ((hash-ref operations (car expression)) (cdr expression) state)
      (mapping-error "unrecognized operation")))