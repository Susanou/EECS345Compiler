#lang racket

(provide (prefix-out INT-
                     (combine-out ADDITION
                                  SUBTRACTION
                                  MULTIPLICATION
                                  DIVISION
                                  MODULO
                                  OPERATOR?)))

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

(define (OPERATOR? x)
  (set-member? OPERATORS x))