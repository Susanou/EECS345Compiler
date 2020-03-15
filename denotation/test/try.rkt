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
   "finally runs after passthrough"
   (try (M-state '(block (var x)
                         (var y)
                         (try (= x 5)
                              (finally
                               (= y 6))))
                 (machine-new))
        (lambda (state)
          (test-equal? "body"
                       (machine-ref state 'x)
                       5)
          (test-equal? "finally"
                       (machine-ref state 'x)
                       5)))))
  
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-try)))
