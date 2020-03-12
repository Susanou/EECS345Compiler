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

(define (value type exp state M-state)
  ((mapper type)    exp state M-state))

(define (bind type exp state M-state)
  (try (value type exp state M-state)
       (lambda (value)
         (success value))))

(define (M-value exp state M-state)
  (try (M-type exp state M-state)
       (lambda (type)
         (bind type exp state M-state))))