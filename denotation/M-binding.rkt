#lang racket

(provide M-binding)

(require "../machine/binding.rkt"
         "../machine/machine-scope.rkt"
         "M-int.rkt"
         "M-bool.rkt"
         "M-type.rkt"
         "mapping.rkt"
         "language.rkt"
         "mapping-utilities.rkt")

(define type-mappers
  (hash  TYPE-INT  M-int
         TYPE-BOOL M-bool
         TYPE-NULL (thunk* (mapping-value null))))

(define (M-binding exp state)
  (let ([mapping (M-type exp state)])
    (if (mapping-value? mapping)
        (mapping-value 
         (let ([type (mapping-value-value mapping)])
           (binding type
                    (mapping-value-value
                     ((hash-ref type-mappers type) exp
                                                   state)))))
        mapping)))