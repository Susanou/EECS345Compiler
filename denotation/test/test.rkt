#!/usr/bin/env racket

#lang racket

(require rackunit
         "M-int.rkt"
         "M-bool.rkt"
         "M-state.rkt"
         "M-type.rkt"
         "machine-update-legacy.rkt")

(define/provide-test-suite
  test-denotation
  test-M-int
  test-M-bool
  test-M-state
  test-M-type
  test-machine-update-legacy)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-denotation)))
