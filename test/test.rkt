#!/usr/bin/env racket

#lang racket

(require rackunit)

(define/provide-test-suite
  test-all)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-all)))
