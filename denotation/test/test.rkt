#!/usr/bin/env racket

#lang racket

(require rackunit
         "M-int.rkt"
         "M-bool.rkt"
         "M-state.rkt")

(define/provide-test-suite
  test-denotation
  test-M-int
  test-M-bool
  test-M-state)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-denotation)))
