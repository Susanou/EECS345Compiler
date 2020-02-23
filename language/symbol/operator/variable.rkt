#lang racket

(provide (prefix-out VARIABLE-
                     (combine-out ASSIGN
                                  DECLARE
                                  OPERATOR?)))

(define ASSIGN  '=  )
(define DECLARE 'var)

(define OPERATORS
  (set ASSIGN
       DECLARE))

(define (OPERATOR? x)
  (set-member? OPERATORS x))