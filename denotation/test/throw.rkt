#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt"
         "../M-state.rkt")

(define/provide-test-suite 
  test-throw
  (test-equal? "error result"
               (M-state '(throw 0)
                        (machine-new))
               (failure "threw: 0")))
  
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-throw)))
