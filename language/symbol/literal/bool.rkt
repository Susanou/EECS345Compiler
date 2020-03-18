#lang racket

(provide TRUE
         FALSE
         BOOL?)

(define TRUE  'true)
(define FALSE 'false)

(define BOOLS
  (set TRUE
       FALSE))

(define (BOOL? x)
  (set-member? BOOLS x))