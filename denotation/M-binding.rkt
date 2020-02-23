#lang racket

(provide M-binding)

(require "../machine/binding.rkt"
         "../machine/machine-scope.rkt"
         "M-int.rkt"
         "M-bool.rkt"
         "M-type.rkt"
         "mapping.rkt"
         "mapping-utilities.rkt"
         "mapping.rkt")

(define type-mappers
  (hash  TYPE-INT  M-int
         TYPE-BOOL M-bool
         TYPE-NULL (thunk* (mapping-value null))))

(define (M-binding exp state)
  (map-bind (M-type exp state)
            (lambda (type)
              (map-bind ((hash-ref type-mappers type) exp state)
                        (lambda (value)
                          (mapping-value (binding type value)))))))