#lang racket

(provide (struct-out machine)
         machine-new)

(struct machine (scopes)
  #:transparent)

(define initial-scopes (list (hash)))

(define (machine-new)
  (machine initial-scopes))