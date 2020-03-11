#lang racket

(provide RESERVED?)

(require "literal.rkt"
         "operator.rkt")

(define RESERVES
  (set LITERAL?
       OPERATOR?))

(define (RESERVED? x)
  (ormap (lambda (p) (p x))
         (set->list RESERVES)))