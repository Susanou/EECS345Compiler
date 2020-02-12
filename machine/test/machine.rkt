#!/usr/bin/env racket

#lang racket

(require rackunit
         "../machine.rkt")

(define/provide-test-suite
  test-machine
  (test-pred "machine-new creates machine"
             machine?
             (machine-new)))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-machine)))
