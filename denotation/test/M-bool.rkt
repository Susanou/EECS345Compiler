#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-bool.rkt")

(define/provide-test-suite 
  test-M-bool
  (test-equal? "false"
               (M-bool 'false null)
               (mapping-value #f)))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-bool)))
