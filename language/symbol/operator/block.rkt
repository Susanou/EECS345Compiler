#lang racket

(provide BLOCK
         BEGIN
         BLOCK-OPERATOR?)

(define BLOCK 'block)
(define BEGIN 'begin)

(define OPERATORS
  (set BLOCK
       BEGIN))

(define (BLOCK-OPERATOR? x)
  (set-member? OPERATORS x))