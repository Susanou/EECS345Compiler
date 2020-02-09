#lang racket

(provide M-bool)

(require "mapping.rkt")

(define constants
  (hash 'true #t
        'false #f))

(define (constant? expression)
  (hash-has-key? constants expression))

(define (constant-mapping-value expression)
      (mapping-value (hash-ref constants expression)))

(define (M-bool expression state)
  (if (constant? expression)
      (constant-mapping-value expression)
      (mapping-error "unsupported")))
