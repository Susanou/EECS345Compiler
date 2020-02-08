#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-bool.rkt")

(define/provide-test-suite 
  test-M-bool
  (test-case
   "constants"
   (check-equal?
     (mapping-value-value (M-bool 'false null))
     #f
     "false maps to #f")
   (check-equal?
     (mapping-value-value (M-bool 'true null))
     #t
     "true maps to #t")))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-bool)))
