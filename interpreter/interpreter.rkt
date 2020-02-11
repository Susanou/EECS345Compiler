#lang racket

(provide interpret
         (struct-out interpreter-value)
         (struct-out interpreter-error))

(struct interpreter-value (value))

(struct interpreter-error (message))

(define (interpret filename)
  null)
