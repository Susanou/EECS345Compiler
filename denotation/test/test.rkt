#!/usr/bin/env racket

#lang racket

(require rackunit
         "M-int.rkt"
         "M-bool.rkt"
         "M-state-legacy.rkt"
         "M-type.rkt"
         "machine-update-legacy.rkt"
         "continue.rkt"
         "int-side-effect.rkt"
         "bool-side-effect.rkt"
         "comparison-side-effect.rkt"
         "throw.rkt"
         "try.rkt"
         "break.rkt"
         "M-state-function-declare.rkt"
         "M-state-function-call.rkt")

(define/provide-test-suite
  test-denotation
  test-M-int
  test-M-bool
  test-M-state-legacy
  test-M-type
  test-machine-update-legacy
  test-continue
  test-int-side-effect
  test-bool-side-effect
  test-comparison-side-effect
  test-throw
  test-try
  test-break
  test-M-function-declare
  test-M-function-call)

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-denotation)))
