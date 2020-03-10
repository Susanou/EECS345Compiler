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
   "external"
   (on (M-state '(block (var x)
                        (var y)
                        (+ (= x 5) (= y 6)))
                (machine-new))
       (lambda (state)
         (test-suite
          "assignment inside addition"
          (test-equal? "first argument"
                       (machine-ref state 'x)
                       5)
          (test-equal? "second argument"
                       (machine-ref state 'y)
                       6)))
       fail))
  (test-suite
   "internal"
   (on (M-state '(block (var x)
                        (var y)
                        (+ (= x 5) (= y (+ 1 x))))
                (machine-new))
       (lambda (state)
         (test-suite
          "assignment inside addition"
          (test-equal? "first argument"
                       (machine-ref state 'x)
                       5)
          (test-equal? "second argument"
                       (machine-ref state 'y)
                       6)))
       fail)))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-int-side-effect)))
