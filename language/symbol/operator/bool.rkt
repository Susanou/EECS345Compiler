#lang racket

(provide NOT
         OR
         AND
         BOOL-OPERATOR?)

(define NOT '! )
(define OR  '||)
(define AND '&&)

(define OPERATORS
  (set NOT
       OR
       AND))

(define (BOOL-OPERATOR? x)
  (set-member? OPERATORS x))