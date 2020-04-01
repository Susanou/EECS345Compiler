#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../M-state.rkt"
         "../../machine/machine.rkt"
         "../../machine/machine-scope.rkt")

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
           (test-equal? "loop ran 5 times"
                        (machine-ref state 'a)
                        0)
           )))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-function-declare)))
