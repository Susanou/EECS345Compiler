#lang racket

(provide IF
         WHILE
         RETURN
         CONTROL-OPERATOR?)

(define IF     'if    )
(define WHILE  'while )
(define RETURN 'return)

(define OPERATORS
  (set IF
       WHILE
       RETURN))

(define (CONTROL-OPERATOR? x)
  (set-member? OPERATORS x))