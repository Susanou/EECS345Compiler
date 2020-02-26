#lang racket

(provide map-variable
         binary-operation
         unary-operation
         unary-binary-operator
         map-operation)

(require "../functional/either.rkt"
         "../machine/binding.rkt"
         "../machine/machine-scope.rkt"
         "../language/expression.rkt")

(define (map-variable type name state)
  (if (machine-scope-bound? state name)
      (let ([binding (machine-scope-ref state name)])
        (if (eq? type (binding-type binding))
            (success (binding-value binding))
            (failure (format "variable not ~s: ~s"
                             type
                             name))))
      (failure (format "use before bind: ~s"
                       name))))

(define (binary-operation operator M-left M-right)
  (lambda (args state)
    (try (M-left  (left-argument  args) state)
         (lambda (left)
           (try (M-right (right-argument args) state)
                (lambda (right)
                  (success (operator left right))))))))

(define (unary-operation operator hand M-value)
  (lambda (args state)
    (try (M-value (hand args) state)
         (lambda (value)
           (success (operator value))))))

(define (unary-binary-operator unary binary)
  (lambda (args state)
    (if (< (length args) 2)
        (unary   args state)
        (binary  args state))))

(define (map-operation operations expression state)
  (let ([operator  (operator  expression)]
        [arguments (arguments expression)])
    (if (hash-has-key? operations operator)
        ((hash-ref     operations operator) arguments state)
        (failure "unrecognized operation"))))