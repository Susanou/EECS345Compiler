#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../M-state.rkt"
         "../../machine/machine.rkt"
         "../../machine/machine-scope.rkt"
         "../../denotation/closure.rkt")

(define/provide-test-suite 
  test-M-function-call
  (test-suite
   "correct binding"
   (on (M-state '(block
                  (var x 4)
                  (function i (x) ((return x)))
                  (var y 5)
                  (var z (funcall i (+ y 1))))
                (machine-new))
       (lambda (state)
         (test-equal? "x unchanged"
                      (machine-ref state 'x)
                      4)
         (test-equal? "y unchanged"
                      (machine-ref state 'y)
                      5)
         (test-equal? "z set to return value"
                      (machine-ref state 'z)
                      6))
       fail)))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-function-call)))
