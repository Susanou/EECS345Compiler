#lang racket

(provide machine-scope-push
         machine-scope-pop
         machine-scope-has?
         machine-level
         machine-plane
         machine-rebase
         machine-bound-top?
         machine-bound-any?
         machine-bind-new
         machine-bind-current
         machine-ref)

(require "machine.rkt")

(define (machine-scope-push state)
  (struct-copy machine
               state
               (scopes (cons (hash)
                             (machine-scopes state)))))
  
(define (machine-scope-pop state)
  (struct-copy machine
               state
               (scopes (rest (machine-scopes state)))))

(define (machine-scope-has? state)
  (not (null? (machine-scopes state))))

(define (machine-level state)
  (length (machine-scopes state)))

(define (machine-plane state level)
  (struct-copy machine
               state
               (scopes (take-right (machine-scopes state)
                                   level))))

(define (machine-rebase base new)
  (struct-copy machine
               new
               (scopes (append (drop-right (machine-scopes new)
                                           (machine-level base))
                               (machine-scopes base)))))

(define (scope-bound? scope name)
  (hash-has-key? scope name))

(define (scope-bound-any? scopes name)
  (and (pair? scopes)
       (or (scope-bound?     (first scopes) name)
           (scope-bound-any? (rest  scopes) name))))

(define (machine-bound-top? state name)
  (scope-bound? (first (machine-scopes state)) name))

(define (machine-bound-any? state name)
  (scope-bound-any? (machine-scopes state) name))

(define (scope-bind-new scope name value)
  (cons (hash-set (first scope) name value)
        (rest scope)))

(define (scope-bind-current scope name value)
  (if (scope-bound?   (first scope) name)
      (cons (hash-set (first scope) name value)
            (rest scope))
      (cons           (first scope)
                      (scope-bind-current (rest scope)
                                          name
                                          value))))

(define (machine-bind-new state name value)
  (struct-copy machine
               state
               (scopes (scope-bind-new (machine-scopes state)
                                       name
                                       value))))

(define (machine-bind-current state name value)
  (struct-copy machine
               state
               (scopes (scope-bind-current (machine-scopes state)
                                           name
                                           value))))

(define (scope-ref scope name)
  (if (scope-bound? (first scope) name)
      (hash-ref     (first scope) name)
      (scope-ref    (rest scope)  name)))

(define (machine-ref state name)
  (scope-ref (machine-scopes state) name))