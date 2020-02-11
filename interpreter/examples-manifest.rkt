#lang racket

(provide examples-manifest
         (struct-out example))

(struct example (name file expected)
  #:transparent)

(require "interpreter.rkt")

(define examples-manifest
  (list (example "return zero"
                 "return-zero.txt"
                 (interpreter-value 0))))
