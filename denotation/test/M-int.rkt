#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-int.rkt")

(define/provide-test-suite 
  test-M-int
  (test-case
   "constants"
   (check-equal?
     (mapping-value-value (M-int 0 null))
     0
     "zero maps to zero")
   (check-equal?
     (mapping-value-value (M-int 1 null))
     1
     "one maps to one")))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-int)))
