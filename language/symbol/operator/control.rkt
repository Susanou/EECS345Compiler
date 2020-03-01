#lang racket

(provide IF
         WHILE
         RETURN
         CONTROL-OPERATOR?
         CONTINUE)

(define IF       'if      )
(define WHILE    'while   )
(define RETURN   'return  )
(define CONTINUE 'continue)

(define OPERATORS
  (set IF
       WHILE
       RETURN
       CONTINUE))

(define (CONTROL-OPERATOR? x)
  (set-member? OPERATORS x))