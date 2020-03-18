#!/usr/bin/env racket

#lang racket

(require rackunit
         "machine.rkt"
         "machine-scope.rkt")

(define/provide-test-suite
  test-all-machine
  test-machine
  test-machine-scope)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-all-machine)))
