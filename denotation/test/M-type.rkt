#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-type.rkt")

(define/provide-test-suite 
  test-M-type
  (test-equal? "zero"
               (M-type 0 null)
               (mapping-value 'INT)))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-type)))
