#lang racket

(provide BINDING-TYPES
         (struct-out binding))

(define BINDING-TYPES '(INT BOOL))

(struct binding (type value)
  #:transparent)
