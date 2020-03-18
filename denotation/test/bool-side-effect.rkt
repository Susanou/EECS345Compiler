#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../../language/symbol/operator/bool.rkt"
         "../M-state.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt")

(define (test-op OP)
  (test-suite
   "OP"
   (on (M-state (quasiquote (block (var x)
                                   (var y)
                                   ((unquote OP) (= x 5)
                                                 (= y (+ 1 x)))))
                (machine-new))
       (lambda (state)
         (test-suite
          "assignment inside arguments"
          (with-check-info (('OP OP))
            (test-equal? "first, external only"
                         (machine-ref state 'x)
                         5)
            (test-equal? "second, internal"
                         (machine-ref state 'y)
                         6))))
       (thunk* (with-check-info (('OP OP))
                 (test-case "OP state" (fail)))))))

(define/provide-test-suite 
  test-bool-side-effect
  (test-op OR )
  (test-op AND)
  (test-suite
   "NOT"
   (on (M-state (quasiquote (block (var x)
                                   (var y)
                                   ((unquote NOT) (= x 5))))
                (machine-new))
       (lambda (state)
         (test-suite
          "assignment inside arguments"
          (test-equal? "first, external only"
                       (machine-ref state 'x)
                       5)))
       (thunk* (test-case "NOT state" (fail))))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-bool-side-effect)))
