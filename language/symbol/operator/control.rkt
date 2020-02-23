#lang racket

(provide (prefix-out CONTROL- (combine-out IF
                                          WHILE
                                          RETURN
                                          OPERATOR?)))

(define IF     'if    )
(define WHILE  'while )
(define RETURN 'return)

(define OPERATORS
  (set IF
       WHILE
       RETURN))

(define (OPERATOR? x)
  (set-member? OPERATORS x))