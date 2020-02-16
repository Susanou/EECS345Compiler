#lang racket

(provide M-type)

(require "mapping.rkt"
         "../machine/machine-scope.rkt"
         "../machine/binding.rkt")

(define boolean-literals
  '(true false))

(define (boolean-literal? expression)
  (member expression boolean-literals))

(define integer-literal?
  integer?)

(define boolean-operators
  '(! || && == != <= >= < >))

(define integer-operators
  '(+ - * / %))

(define (operator-expression-check operators)
  (lambda (expression)
    (and (pair? expression)
         (member (car expression)
                 operators))))

(define boolean-operator?
  (operator-expression-check boolean-operators))

(define integer-operator?
  (operator-expression-check integer-operators))

(define variable? symbol?)

(define (variable-type-mapping name state)
  (if (machine-scope-bound? state name)
      (mapping-value (binding-type (machine-scope-ref state name)))
      (mapping-error "unbound variable")))

(define (M-type expression state)
  (cond [(or (boolean-literal?  expression)
             (boolean-operator? expression))
         (mapping-value 'BOOL)]
        
        [(or(integer-literal?   expression)
            (integer-operator?  expression))
         (mapping-value 'INT)]
        
        [(variable?             expression)
         (variable-type-mapping expression state)]

        [(eq? (first expression) '=) (M-type (third expression) state)]
        
        [else
         (mapping-error "unrecognized type")]))