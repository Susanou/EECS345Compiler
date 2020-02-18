#lang racket

(provide M-type)

(require "mapping.rkt"
         "../machine/machine-scope.rkt"
         "../machine/binding.rkt"
         "mapping-utilities.rkt")

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

(define (variable-type-mapping name state)
  (if (machine-scope-bound? state name)
      (mapping-value (binding-type (machine-scope-ref state name)))
      (mapping-error (format "use before declare: ~s"
                             name))))

(define (M-type expression state)
  (cond [(or (lang-boolean?  expression)
             (boolean-operator? expression))
         (mapping-value 'BOOL)]
        
        [(or(lang-integer?   expression)
            (integer-operator?  expression))
         (mapping-value 'INT)]
        
        [(lang-variable?             expression)
         (variable-type-mapping expression state)]

        [(eq? (first expression) '=) (M-type (third expression) state)]
        
        [else
         (mapping-error "unrecognized type")]))