#!/usr/bin/env racket

#lang racket

(require rackunit
         "../parser/test.rkt")

(define/provide-test-suite
  test-all
  test-parser)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-all)))
