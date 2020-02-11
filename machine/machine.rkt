#lang racket

(provide BINDING-TYPES
         (struct-out binding)
         (struct-out machine)
         machine-scope-bound?
         machine-scope-bind
         machine-scope-ref
         machine-new)

(define BINDING-TYPES '(INT BOOL))

(struct binding (type value)
  #:transparent)

(struct machine (scope)
  #:transparent)

(define (machine-new)
  (machine (hash)))

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