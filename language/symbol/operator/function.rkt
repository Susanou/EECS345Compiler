#lang racket

(provide FUNCTION-DECLARE
         FUNCTION-CALL
         ENTRY-FUNCTION
         FUNCTION-OPERATOR?)

(define FUNCTION-DECLARE 'function)
(define FUNCTION-CALL        'funcall)
(define ENTRY-FUNCTION       'main)

(define OPERATORS
  (set FUNCTION-DECLARE
       FUNCTION-CALL))

(define (FUNCTION-OPERATOR? x)
  (set-member? OPERATORS x))
