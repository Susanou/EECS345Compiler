#lang racket

(provide M-value)

(require "../functional/either.rkt"
         "../language/type.rkt"
         "../language/expression.rkt"
         "M-int.rkt"
         "M-bool.rkt"
         "M-type.rkt")

(define M-null
  (thunk* (success null)))

(define mappers
  (hash  INT       M-int
         BOOL      M-bool
         NULL-TYPE M-null))

(define (mapper     type)
  (hash-ref mappers type))

(define (value type exp state M-state throw)
  ((mapper type)    exp state M-state throw))

(define (bind type exp state M-state throw)
  (try (value type exp state M-state throw)
       (lambda (value)
         (success value))))

(define (M-value exp state M-state throw)
  (if (FUNCTION-CALL-EXPRESSION? exp)
      (let/cc r
        (try (M-state exp
                      state
                      throw
                      (lambda (value state)
                        (r (success value))))
             (lambda (state)
               (success null))))     
      (try (M-type      exp state M-state throw)
           (lambda (type)
             (bind type exp state M-state throw)))))