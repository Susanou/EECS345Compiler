#lang racket

(provide interpret
         (struct-out interpreter-value)
         (struct-out interpreter-error))

(struct interpreter-value (value)
  #:transparent)

(struct interpreter-error (message)
  #:transparent)

(define (interpret filename)
  (interpreter-value 0))
