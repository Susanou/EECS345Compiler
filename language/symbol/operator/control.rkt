#lang racket

(provide IF
         WHILE
         RETURN
         CONTINUE
         THROW
         TRY
         CONTROL-OPERATOR?)

(define IF       'if      )
(define WHILE    'while   )
(define RETURN   'return  )
(define CONTINUE 'continue)
(define THROW    'throw   )
(define TRY      'try     )

(define OPERATORS
  (set IF
       WHILE
       RETURN
       CONTINUE
       THROW
       TRY))

(define (CONTROL-OPERATOR? x)
  (set-member? OPERATORS x))