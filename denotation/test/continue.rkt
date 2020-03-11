#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt"
         "../M-state.rkt")

(define/provide-test-suite 
  test-continue
  (test-equal? "error result"
               (M-state '(continue)
                        (machine-new))
               (failure "continue outside loop"))
  (let ([mstate (M-state '(block
                           (var x 0)
                           (var y 0)
                           (while (< x 5)
                                  (begin
                                    (= x (+ x 1))
                                    (if (> x 2)
                                        (continue))
                                    (= y (+ y 1)))))
                         (machine-new))])
    (test-pred "successful result"
               success?
               mstate)
    (on mstate
        (lambda (state)
          (test-equal? "loop ran 5 times"
                       (machine-ref state 'x)
                       5)
          (test-equal? "loop continued thrice"
                       (machine-ref state 'y)
                       2)))))
  
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-continue)))
