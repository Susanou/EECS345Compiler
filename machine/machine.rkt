#lang racket

(provide (struct-out machine)
         machine-new)

(struct machine (scope)
  #:transparent)

(define (machine-new)
  (machine (hash)))
