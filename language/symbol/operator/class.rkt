#lang racket

(provide CLASS-DECLARE
         CLASS-CALL
         CLASS-OPERATOR)

(define CLASS-DECLARE 'class)
(define CLASS-CALL    'classcall)

(define OPERATORS
    (set CLASS-CALL
         CLASS-DECLARE))

(define (CLASS-OPERATOR? x)
  (set-member? OPERATORS x))