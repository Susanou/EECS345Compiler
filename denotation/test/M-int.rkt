#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-int.rkt")

(define/provide-test-suite 
  test-M-int
  (test-equal? "zero"
               (M-int 0 null)
               (mapping-value 0)))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-int)))
