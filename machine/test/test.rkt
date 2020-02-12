#!/usr/bin/env racket

#lang racket

(require rackunit
         "binding.rkt"
         "machine.rkt"
         "machine-scope.rkt")

(define/provide-test-suite
  test-all-machine
  test-binding
  test-machine
  test-machine-scope)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-all-machine)))
