#!/usr/bin/env racket

#lang racket

(require rackunit
         "../binding.rkt")

(define/provide-test-suite
  test-binding)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-binding)))
