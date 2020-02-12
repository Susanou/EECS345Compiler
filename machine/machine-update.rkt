#lang racket

(provide (struct-out result-void)
         (struct-out result-return)
         (struct-out result-error)
         machine-update
         machine-consume)

(require "machine-scope.rkt")

(struct result-void ()
  #:transparent)

(struct result-return (value)
  #:transparent)

(struct result-error (message)
  #:transparent)

(define (machine-update state statement)
  (if (equal? '(var x) statement)
      (values (result-void)
              (machine-scope-bind state 'x 0))
      (values (result-return 0)
              state)))

(define (machine-consume state statements)
  (values (result-return 0) state))
