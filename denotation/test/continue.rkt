#!/usr/bin/env racket

#lang racket

(require rackunit
         "../M-state.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt")

(define/provide-test-suite 
  test-continue)
  
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-continue)))
