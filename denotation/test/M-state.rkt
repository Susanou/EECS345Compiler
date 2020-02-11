#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-state.rkt")

(define/provide-test-suite 
  test-M-state
  (test-equal? "null"
               (M-state null null)
               (mapping-value null)))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-state)))
