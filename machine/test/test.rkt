#!/usr/bin/env racket

#lang racket

(require rackunit
         "binding.rkt"
         "machine.rkt"
         "machine-scope.rkt"
         "machine-update.rkt")

(define/provide-test-suite
  test-all-machine
  test-binding
  test-machine
  test-machine-scope
  test-machine-update)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-all-machine)))
