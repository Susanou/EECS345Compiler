#lang racket

(provide (prefix-out COMPARISON-
                     (combine-out
                      EQUAL
                      NOT-EQUAL
                      LESS-THAN-OR-EQUAL
                      GREATER-THAN-OR-EQUAL
                      LESS-THAN
                      GREATER-THAN
                      OPERATOR?)))

(define EQUAL                 '==)
(define NOT-EQUAL             '!=)
(define LESS-THAN-OR-EQUAL    '<=)
(define GREATER-THAN-OR-EQUAL '>=)
(define LESS-THAN             '< )
(define GREATER-THAN          '> )

(define OPERATORS
  (set EQUAL
       NOT-EQUAL
       LESS-THAN-OR-EQUAL
       GREATER-THAN-OR-EQUAL
       LESS-THAN
       GREATER-THAN))

(define (OPERATOR? x)
  (set-member? OPERATORS x))