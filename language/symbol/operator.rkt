#lang racket

(provide OPERATOR?)

(require "operator/bool.rkt"
         "operator/comparison.rkt"
         "operator/control.rkt"
         "operator/int.rkt"
         "operator/variable.rkt"
         "operator/block.rkt")

(define OPERATORS
  (set BOOL-OPERATOR?
       COMPARISON-OPERATOR?
       CONTROL-OPERATOR?
       INT-OPERATOR?
       VARIABLE-OPERATOR?
       BLOCK-OPERATOR?))

(define (OPERATOR? x)
  (ormap (lambda (p) (p x))
         (set->list OPERATORS)))