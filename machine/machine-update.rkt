#lang racket

(provide (struct-out result-void)
         (struct-out result-return)
         (struct-out result-error)
         machine-update
         machine-consume)

(struct result-void ()
  #:transparent)

(struct result-return (value)
  #:transparent)

(struct result-error (message)
  #:transparent)

(define (machine-update state statement)
  (values (result-return 0) state))

(define (machine-consume state statements)
  (values (result-return 0) state))
