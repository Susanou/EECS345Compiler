#lang racket

(provide map-variable
         binary-operation
         unary-operation
         unary-operation-right-hand
         unary-binary-operator
         map-operation)

(require "mapping.rkt"
         "../machine/binding.rkt"
         "../machine/machine-scope.rkt"
         "language.rkt")

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
     (operator (mapping-value-value (M-left  (args-left  args) state))
               (mapping-value-value (M-right (args-right args) state))))))

(define (unary-operation operator M-value)
  (lambda (args state)
    (mapping-value
     (operator (mapping-value-value (M-value (args-left  args) state))))))

(define (unary-operation-right-hand operator M-value)
  (lambda (args state)
    (mapping-value
     (operator (mapping-value-value (M-value (args-right  args) state))))))

(define (unary-binary-operator unary binary)
  (lambda (args state)
    (if (< (length args) 2)
        (unary   args state)
        (binary  args state))))

(define (map-operation operations expression state)
  (let ([operator  (exp-op   expression)]
        [arguments (exp-args expression)])
    (if (hash-has-key? operations operator)
        ((hash-ref     operations operator) arguments state)
        (mapping-error "unrecognized operation"))))