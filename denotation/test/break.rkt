#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt"
         "../M-state.rkt")

(define/provide-test-suite 
  test-break
  (test-equal? "error result"
               (M-state '(break)
                        (machine-new))
               (failure "break outside loop"))
  (on (M-state '(block
                 (var x 0)
                 (var y 0)
                 (while (< x 5)
                        (begin
                          (= x (+ x 1))
                          (if (> x 2)
                              (break))
                          (= y (+ y 1)))))
               (machine-new))
      (lambda (state)
        (test-equal? "loop ran 3 times"
                     (machine-ref state 'x)
                     3)
        (test-equal? "loop broke in middle"
                     (machine-ref state 'y)
                     2))
      fail))
  
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-break)))
