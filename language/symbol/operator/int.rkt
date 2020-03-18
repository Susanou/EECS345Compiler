#lang racket

(provide ADDITION
         SUBTRACTION
         MULTIPLICATION
         DIVISION
         MODULO
         INT-OPERATOR?)

(define ADDITION       '+)
(define SUBTRACTION    '-)
(define MULTIPLICATION '*)
(define DIVISION       '/)
(define MODULO         '%)

(define OPERATORS
  (set ADDITION
       SUBTRACTION
       MULTIPLICATION
       DIVISION
       MODULO))

(define (INT-OPERATOR? x)
  (set-member? OPERATORS x))