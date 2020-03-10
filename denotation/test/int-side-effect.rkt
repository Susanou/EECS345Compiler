#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../M-state.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt")

(define/provide-test-suite 
  test-int-side-effect
  (test-suite
   "addition"
   (on (M-state '(block (var x)
                        (var y)
                        (+ (= x 5) (= y (+ 1 x))))
                (machine-new))
       (lambda (state)
         (test-suite
          "assignment inside arguments"
          (test-equal? "first, external only"
                       (machine-ref state 'x)
                       5)
          (test-equal? "second, internal"
                       (machine-ref state 'y)
                       6)))
       fail)))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-int-side-effect)))
