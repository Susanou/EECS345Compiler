#lang racket

(provide map-variable
         binary-operation
         unary-operation
         unary-binary-operator
         map-operation)

(require "../functional/either.rkt"
         "../language/type.rkt"
         "../language/expression.rkt"
         "../machine/machine-scope.rkt"
         "closure.rkt")

(define type-checkers
  (hash NULL-TYPE null?
        BOOL      boolean?
        INT       integer?
        CLOSURE   closure?))

(define (is value          type)
  ((hash-ref type-checkers type) value))

(define (map-variable type name state)
  (if (machine-bound-any? state name)
      (let ([value (machine-ref state name)])
        (if (is      value type)
            (success value)
            (failure (format "variable not ~s: ~s"
                             type
                             name))))
      (failure (format "use before bind: ~s"
                       name))))

(define (binary-operation operator M-left M-right)
  (lambda (args state M-state M-value throw)
    (try (M-left  (left-argument args)
                  state
                  M-state
                  M-value
                  throw)
         (lambda (left)
           (try (M-state (left-argument args)
                         state
                         throw)
                (lambda (state)
                  (try (M-right (right-argument args)
                                state
                                M-state
                                M-value
                                throw)
                       (lambda (right)
                         (success (operator left right))))))))))

(define (unary-operation operator hand M-single)
  (lambda (args state M-state M-value throw)
    (try (M-single (hand args)
                  state
                  M-state
                  M-value
                  throw)
         (lambda (value)
           (success (operator value))))))

(define (unary-binary-operator unary binary)
  (lambda (args state M-state M-value throw)
    ((cond [(single-argument? args) unary]
           [(binary-argument? args) binary]) args
                                             state
                                             M-state
                                             M-value
                                             throw)))

(define (map-operator operations expression)
  (hash-ref operations
            (operator expression)
            (thunk* (failure "unrecognized operation"))))

(define (map-operation operations
                       expression
                       state
                       M-state
                       M-value
                       throw)
  ((map-operator operations expression) (arguments expression)
                                        state
                                        M-state
                                        M-value
                                        throw))
