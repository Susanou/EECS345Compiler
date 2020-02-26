#lang racket

(provide M-binding)

(require "../machine/binding.rkt"
         "M-int.rkt"
         "M-bool.rkt"
         "M-type.rkt"
         "../functional/either.rkt")

(define type-mappers
  (hash  TYPE-INT  M-int
         TYPE-BOOL M-bool
         TYPE-NULL (thunk* (success null))))

(define (M-binding exp state)
  (try (M-type exp state)
       (lambda (type)
         (try ((hash-ref type-mappers type) exp state)
              (lambda (value)
                (success (binding type value)))))))