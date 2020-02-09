#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-bool.rkt")

(define MAPPING-TRUE  (mapping-value #t))
(define MAPPING-FALSE (mapping-value #f))

(define/provide-test-suite 
  test-M-bool
  (test-suite
   "constants"
   
   (test-case
    "false"
    (check-equal?
     (M-bool 'false null)
     MAPPING-FALSE
     "false maps to #f"))
   
   (test-case
    "true"
    (check-equal?
     (M-bool 'true null)
     MAPPING-TRUE
     "true maps to #t")))

  (test-suite
   "operations"

   (test-case
    "! true"
    (check-equal?
     (M-bool '(! true) null)
     MAPPING-FALSE))

   (test-case
    "! false"
    (check-equal?
     (M-bool '(! false) null)
     MAPPING-TRUE)))


  (test-suite
   "nested operations"

   (test-case
    "! ! true"
    (check-equal?
     (M-bool '(! (! true)) null)
     MAPPING-TRUE))

   (test-case
    "! ! false"
    (check-equal?
     (M-bool '(! (! false)) null)
     MAPPING-FALSE)))
  
  
  (test-suite
   "conversion"
   
   (test-case
    "zero"
    (check-equal?
     (M-bool 0 null)
     MAPPING-FALSE
     "zero maps to #f"))
   
   (test-case
    "one"
    (check-equal?
     (M-bool 1 null)
     MAPPING-TRUE
     "one maps to #t"))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-bool)))
