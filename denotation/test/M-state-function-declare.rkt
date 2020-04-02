#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../M-state.rkt"
         "../../machine/machine.rkt"
         "../../machine/machine-scope.rkt"
         "../../denotation/closure.rkt")

(define/provide-test-suite 
  test-M-function-declare
  (test-suite
   "correct binding"
   (let ([mstate (M-state '(block
                            (function a (x y) ((return (+ x y)))))
                          (machine-new))])
     (test-pred "successful result"
                success?
                mstate)
     (on mstate
         (lambda (state)
           (test-pred "bound closure to name"
                      closure?
                      (machine-ref state 'a)))))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-function-declare)))
