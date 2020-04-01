#lang racket

(provide FUNCTION-DECLARATION
         FUNCTION-CALL
         ENTRY-FUNCTION
         FUNCTION-OPERATOR?)

(define FUNCTION-DECLARATION 'function)
(define FUNCTION-CALL        'funcall)
(define ENTRY-FUNCTION       'main)

(define OPERATORS
  (set FUNCTION-DECLARATION
       FUNCTION-CALL))

(define (FUNCTION-OPERATOR? x)
  (set-member? OPERATORS x))
