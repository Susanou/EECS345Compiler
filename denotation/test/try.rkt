#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt"
         "../M-state.rkt")

(define/provide-test-suite 
  test-try
  (test-suite
   "bare try"
   (on (M-state '(block (var x)
                        (try (= x 5)))
                (machine-new))
       (lambda (state)
         (test-equal? "body"
                      (machine-ref state 'x)
                      5))
       fail))
  (test-suite
   "finally runs after passthrough"
   (on (M-state '(block (var x)
                        (var y)
                        (try (= x 5)
                             (finally (= y 6))))
                (machine-new))
       (lambda (state)
         (test-equal? "body"
                      (machine-ref state 'x)
                      5)
         (test-equal? "finally"
                      (machine-ref state 'y)
                      6))
       fail))
  (test-suite
   "catch does not run after passthrough"
   (on (M-state '(block (var x)
                        (var y 2)
                        (try (= x 5)
                             (catch (= y 6))))
                (machine-new))
       (lambda (state)
         (test-equal? "body"
                      (machine-ref state 'x)
                      5)
         (test-equal? "catch"
                      (machine-ref state 'y)
                      2))
       fail))
  (test-suite
   "catch does not run after passthrough, but finally does"
   (on (M-state '(block (var x)
                        (var y 2)
                        (var z)
                        (try (= x 5)
                             (catch (= y 6))
                             (finally (= z 12))))
                (machine-new))
       (lambda (state)
         (test-equal? "body"
                      (machine-ref state 'x)
                      5)
         (test-equal? "catch"
                      (machine-ref state 'y)
                      2)
         (test-equal? "finally"
                      (machine-ref state 'z)
                      12))
       fail)))
  
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-try)))
