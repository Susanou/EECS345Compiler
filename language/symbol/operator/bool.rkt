#lang racket

(provide (prefix-out BOOL-
                     (combine-out NOT
                                  OR
                                  AND
                                  OPERATOR?)))

(define NOT '! )
(define OR  '||)
(define AND '&&)

(define OPERATORS
  (set NOT
       OR
       AND))

(define (OPERATOR? x)
  (set-member? OPERATORS x))