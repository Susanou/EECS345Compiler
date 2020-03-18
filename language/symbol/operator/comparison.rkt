#lang racket

(provide EQUAL
         NOT-EQUAL
         LESS-OR-EQUAL
         GREATER-OR-EQUAL
         LESS
         GREATER
         COMPARISON-OPERATOR?)

(define EQUAL            '==)
(define NOT-EQUAL        '!=)
(define LESS-OR-EQUAL    '<=)
(define GREATER-OR-EQUAL '>=)
(define LESS             '< )
(define GREATER          '> )

(define OPERATORS
  (set EQUAL
       NOT-EQUAL
       LESS-OR-EQUAL
       GREATER-OR-EQUAL
       LESS
       GREATER))

(define (COMPARISON-OPERATOR? x)
  (set-member? OPERATORS x))