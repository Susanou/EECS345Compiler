#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-int.rkt")

(define/provide-test-suite 
  test-M-int
  (test-equal? "zero"
               (M-int 0 null)
               (mapping-value 0))
  (test-equal? "1 + 2"
               (M-int '(+ 1 2) null)
               (mapping-value 3)))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-int)))
