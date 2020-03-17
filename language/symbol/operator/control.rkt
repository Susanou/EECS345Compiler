#lang racket

(provide IF
         WHILE
         RETURN
         CONTINUE
         THROW
         CONTROL-OPERATOR?)

(define IF       'if      )
(define WHILE    'while   )
(define RETURN   'return  )
(define CONTINUE 'continue)
(define THROW    'throw)

(define OPERATORS
  (set IF
       WHILE
       RETURN
       CONTINUE
       THROW))

(define (CONTROL-OPERATOR? x)
  (set-member? OPERATORS x))