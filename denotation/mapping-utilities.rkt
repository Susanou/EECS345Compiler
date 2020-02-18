#lang racket

(provide map-variable
         binary-operation
         unary-operation
         unary-binary-operator
         expression-operator
         expression-left
         expression-right   
         expression-single
         expression-arguments
         arguments-left     
         arguments-right)

(require "mapping.rkt"
         "../machine/binding.rkt"
         "../machine/machine-scope.rkt")

(define expression-operator  first)
(define expression-left      second)
(define expression-right     third)
(define expression-single    second)

(define expression-arguments rest)

(define arguments-left       first)
(define arguments-right      second)

(define (map-variable type name state)
  (if (machine-scope-bound? state name)
      (let ([binding (machine-scope-ref state name)])
        (if (eq? type (binding-type binding))
            (mapping-value (binding-value binding))
            (mapping-error (format "variable not ~s: ~s"
                                   type
                                   name))))
      (mapping-error (format "use before bind: ~s"
                             name))))

(define (binary-operation operator M-left M-right)
  (lambda (args state)
    (mapping-value
     (operator (mapping-value-value (M-left  (first  args) state))
               (mapping-value-value (M-right (second args) state))))))

(define (unary-operation operator M-value)
  (lambda (args state)
    (mapping-value
     (operator (mapping-value-value (M-value (first  args) state))))))

(define (unary-binary-operator unary binary)
  (lambda (args state)
    (if (< (length args) 2)
        (unary   args state)
        (binary  args state))))