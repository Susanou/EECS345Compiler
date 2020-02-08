#!/usr/bin/env racket

#lang racket

(require rackunit
         "M-int.rkt")

(define/provide-test-suite
  test-denotation
  test-M-int)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-denotation)))
