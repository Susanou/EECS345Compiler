#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-state.rkt"
         "../../machine/machine.rkt")

(define/provide-test-suite 
  test-M-state
  (test-equal? "state unchanged by interger constant"
               (M-state 0 (machine-new))
               (mapping-value (machine-new))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-state)))
