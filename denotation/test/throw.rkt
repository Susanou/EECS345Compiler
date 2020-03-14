#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt"
         "../M-state.rkt")

(define/provide-test-suite 
  test-throw
  (let/cc c
    (M-state '(throw 0)
             (machine-new)
             (lambda (cause state)
               (c (test-equal? "threw"
                               cause
                               0))))
    (fail "no throw")))
  
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-throw)))
