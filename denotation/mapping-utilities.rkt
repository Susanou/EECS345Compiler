#lang racket

(provide map-variable
         binary-operation
         unary-operation
         unary-operation-right-hand
         unary-binary-operator
         expression-operator
         expression-left
         expression-right   
         expression-single
         expression-arguments
         arguments-left     
         arguments-right
         map-operation
         lang-expression?
         lang-variable?
         lang-integer?
         lang-boolean-literals
         lang-boolean?)

(require "mapping.rkt"
         "../machine/binding.rkt"
         "../machine/machine-scope.rkt")


(define lang-expression? list?)
(define lang-variable?   symbol?)
(define lang-integer?    integer?)

(define lang-boolean-literals
  '(true false))

(define (lang-boolean? x)
  (member x lang-boolean-literals))

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
     (operator (mapping-value-value (M-left  (arguments-left  args) state))
               (mapping-value-value (M-right (arguments-right args) state))))))

(define (unary-operation operator M-value)
  (lambda (args state)
    (mapping-value
     (operator (mapping-value-value (M-value (arguments-left  args) state))))))

(define (unary-operation-right-hand operator M-value)
  (lambda (args state)
    (mapping-value
     (operator (mapping-value-value (M-value (arguments-right  args) state))))))

(define (unary-binary-operator unary binary)
  (lambda (args state)
    (if (< (length args) 2)
        (unary   args state)
        (binary  args state))))

(define (map-operation operations expression state)
  (let ([operator  (expression-operator expression)]
        [arguments (expression-arguments expression)])
    (if (hash-has-key? operations operator)
        ((hash-ref     operations operator) arguments state)
        (mapping-error "unrecognized operation"))))