#lang racket

(provide BLOCK
         BLOCK-OPERATOR?)

(define BLOCK 'block)

(define OPERATORS
  (set BLOCK))

(define (BLOCK-OPERATOR? x)
  (set-member? OPERATORS x))