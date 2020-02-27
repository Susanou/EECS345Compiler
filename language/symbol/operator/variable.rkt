#lang racket

(provide ASSIGN
         DECLARE
         VARIABLE-OPERATOR?)

(define ASSIGN  '=  )
(define DECLARE 'var)

(define OPERATORS
  (set ASSIGN
       DECLARE))

(define (VARIABLE-OPERATOR? x)
  (set-member? OPERATORS x))