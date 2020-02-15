#lang racket

(provide M-type)

(require "mapping.rkt")

(define BOOL 'BOOL)
(define INT  'INT)

(define MAPPING-BOOL (mapping-value BOOL))
(define MAPPING-INT  (mapping-value INT))

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

(define (M-type expression state)
  (cond [(boolean-literal?  expression) MAPPING-BOOL]
        [(boolean-operator? expression) MAPPING-BOOL]
        [(integer-literal?  expression) MAPPING-INT]
        [(integer-operator? expression) MAPPING-INT]
        [else
         (mapping-error "unsupported type")]))