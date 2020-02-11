#!/usr/bin/env racket

#lang racket

(require rackunit
         "../parser/test.rkt"
         "../interpreter/test.rkt")

(define/provide-test-suite
  test-all
  test-parser
  test-interpreter)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-all)))
