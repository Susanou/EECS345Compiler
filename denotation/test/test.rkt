#!/usr/bin/env racket

#lang racket

(require rackunit
         "M-int.rkt"
         "M-bool.rkt")

(define/provide-test-suite
  test-denotation
  test-M-int
  test-M-bool)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-denotation)))
