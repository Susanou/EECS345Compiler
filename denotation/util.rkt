#lang racket

(provide map-variable
         binary-operation
         unary-operation
         unary-binary-operator
         map-operation)

(require "../functional/either.rkt"
         "../language/type.rkt"
         "../language/expression.rkt"
         "../machine/machine-scope.rkt")

(define type-checkers
  (hash NULL-TYPE null?
        BOOL      boolean?
        INT       integer?))

(define (check-type type value)
  ((hash-ref type-checkers type) value))

(define (map-variable type name state)
  (if (machine-bound-any? state name)
      (let ([value (machine-ref state name)])
        (if (check-type type value)
            (success value)
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
    ((cond [(single-argument? args) unary]
           [(binary-argument? args) binary]) args state)))

(define (map-operation operations expression state)
  (let ([operator  (operator  expression)])
    (if (hash-has-key? operations operator)
        ((hash-ref     operations operator) (arguments expression) state)
        (failure "unrecognized operation"))))