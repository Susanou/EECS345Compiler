#lang racket

(provide M-type)

(require "mapping.rkt"
         "../machine/machine-scope.rkt"
         "../machine/binding.rkt")

(define BOOL 'BOOL)
(define INT  'INT)

(define MAPPING-BOOL (mapping-value BOOL))
(define MAPPING-INT  (mapping-value INT))
(define MAPPING-NULL  (mapping-value 'NULL))

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

(define (variable-type name state)
  (if (machine-scope-bound? state name)
      (mapping-value (binding-type (machine-scope-ref state name)))
      (mapping-error "unbound variable")))

(define (M-type expression state)
  (cond [(boolean-literal?  expression) MAPPING-BOOL]
        [(boolean-operator? expression) MAPPING-BOOL]
        [(integer-literal?  expression) MAPPING-INT]
        [(integer-operator? expression) MAPPING-INT]
        [(variable? expression)
         (variable-type expression state)]
        [else
         (mapping-error "unrecognized type")]))