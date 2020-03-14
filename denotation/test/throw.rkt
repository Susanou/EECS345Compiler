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
    (test-case "throw value"
               (fail "no throw")))
  (let/cc c
    (M-state '(block
               (var x)
               (begin
                 (var y)
                 (throw 0)))
             (machine-new)
             (lambda (cause state)
               (c (test-suite
                   "correct scope level"
                   (test-equal? "x in scope"
                                (machine-bound-any? state 'x)
                                #t)
                   (test-equal? "y not in scope"
                                (machine-bound-any? state 'y)
                                #f)))))
    (test-case "throw unwraps lexical scope"
               (fail "no throw")))
  (let/cc c
    (M-state '(block
               (var x)
               (throw (= x 5)))
             (machine-new)
             (lambda (cause state)
               (c (test-equal? "side effects"
                               (machine-ref state 'x)
                               5))))
    (test-case "side effects"
               (fail "no throw"))))
  
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-throw)))
