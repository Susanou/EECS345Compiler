#!/usr/bin/env racket

#lang racket

(require rackunit
         "../parser/test.rkt"
         "../interpreter/test.rkt"
         "../machine/test/test.rkt")

(define/provide-test-suite
  test-all
  test-parser
  test-interpreter
  test-all-machine)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-all)))
