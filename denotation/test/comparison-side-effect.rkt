#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../../language/symbol/operator/comparison.rkt"
         "../M-state.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt")

(define (test-op OP)
  (test-suite
   "OP"
   (on (M-state (quasiquote (block (var x)
                                   (var y)
                                   ((unquote OP) (= x true)
                                                 (= y (|| x false)))))
                (machine-new))
       (lambda (state)
         (test-suite
          "assignment inside arguments"
          (with-check-info (('OP OP))
            (test-equal? "first, external only"
                         (machine-ref state 'x)
                         #t)
            (test-equal? "second, internal"
                         (machine-ref state 'y)
                         #t))))
       (lambda (message)
         (with-check-info (('OP OP))
           (test-case "OP state" (fail message)))))))

(define/provide-test-suite 
  test-comparison-side-effect
  (test-op EQUAL           )
  (test-op NOT-EQUAL       )
  (test-op LESS-OR-EQUAL   )
  (test-op GREATER-OR-EQUAL)
  (test-op LESS            )
  (test-op GREATER         ))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-comparison-side-effect)))
