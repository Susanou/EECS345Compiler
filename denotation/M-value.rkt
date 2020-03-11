#lang racket

(provide M-value)

(require "../functional/either.rkt"
         "../language/type.rkt"
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

(define (value type exp state)
  ((mapper type)    exp state))

(define (bind type exp state)
  (try (value type exp state)
       (lambda (value)
         (success value))))

(define (M-value exp state)
  (try (M-type exp state)
       (lambda (type)
         (bind type exp state))))