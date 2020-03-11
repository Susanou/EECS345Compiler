#lang racket

(provide LITERAL?)

(require (only-in "literal/bool.rkt"
                  BOOL?)
         (only-in "literal/int.rkt"
                  INT?))

(define LITERALS
  (set BOOL?
       INT?))

(define (LITERAL? x)
  (ormap (lambda (p) (p x))
         (set->list LITERALS)))