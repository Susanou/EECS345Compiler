#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-state.rkt"
         "../../machine/binding.rkt"
         "../../machine/machine.rkt"
         "../../machine/machine-scope.rkt")

(define/provide-test-suite 
  test-M-state
  (test-suite
   "state unchanged by interger constant"
   (let-values ([(result state)
                 (M-state 0 (machine-new))])
     (test-pred "result is void"
                result-void?
                result)
     (test-equal? "state unchanged"
                  state
                  (machine-new))))
  (test-suite
   "state has variable after var expression"
   (let-values ([(result state)
                 (M-state '(var x) (machine-new))])
     (test-pred "result is void"
                result-void?
                result)
     (test-true "variable bound"
                (machine-scope-bound? state 'x)))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-state)))
