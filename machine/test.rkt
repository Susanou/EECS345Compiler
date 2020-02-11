#!/usr/bin/env racket

#lang racket

(require rackunit
         "machine.rkt")

(define/provide-test-suite
  test-machine)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-machine)))
