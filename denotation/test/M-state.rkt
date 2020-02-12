#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-state.rkt"
         "../../machine/machine.rkt"
         "../../machine/machine-scope.rkt")

(define/provide-test-suite 
  test-M-state
  (test-equal? "state unchanged by interger constant"
               (M-state 0 (machine-new))
               (mapping-value (machine-new)))
  (test-case "state has variable after var expression"
             (let ([mapping
                    (M-state '(var x) (machine-new))])
               (check-pred mapping-value? mapping)
               (check-true (machine-scope-bound?
                            (mapping-value-value mapping)
                            'x)))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-state)))
