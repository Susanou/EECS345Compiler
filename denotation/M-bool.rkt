#lang racket

(provide M-bool)

(require "mapping.rkt")

(define constants
  (hash 'true #t
        'false #f))

(define (M-bool expression state)
  (if (hash-has-key? constants expression)
      (mapping-value (hash-ref constants expression))
      (mapping-error "unsupported")))
