#lang racket

(provide M-binding)

(require "../functional/either.rkt"
         "../machine/binding.rkt"
         "M-int.rkt"
         "M-bool.rkt"
         "M-type.rkt")

(define M-null
  (thunk* (success null)))

(define mappers
  (hash  TYPE-INT  M-int
         TYPE-BOOL M-bool
         TYPE-NULL M-null))

(define (mapper type)
  (hash-ref mappers type))

(define (value type exp state)
  ((mapper type) exp state))

(define (bind type exp state)
  (try (value type exp state)
       (lambda (value)
         (success (binding type value)))))

(define (M-binding exp state)
  (try (M-type exp state)
       (lambda (type)
         (bind type exp state))))