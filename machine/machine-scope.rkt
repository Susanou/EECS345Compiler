#lang racket

(provide machine-scope-bound?
         machine-scope-bind
         machine-scope-ref)

(require "machine.rkt")

(define (machine-scope-bound? state name)
  (hash-has-key? (machine-scope state)
                 name))

(define (machine-scope-bind state name binding)
  (struct-copy machine
               state
               (scope
                (hash-set
                 (machine-scope state)
                 name
                 binding))))

(define (machine-scope-ref state name)
  (hash-ref (machine-scope state)
            name))
