#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../../language/symbol/operator/int.rkt"
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
  test-int-side-effect
  (test-op ADDITION      )
  (test-op SUBTRACTION   )
  (test-op MULTIPLICATION)
  (test-op DIVISION      )
  (test-op MODULO        )
  (test-suite
   "unary minus"
   (on (M-state '(block (var x)
                        (- (= x 5)))
                (machine-new))
       (lambda (state)
         (test-equal? "single"
                      (machine-ref state 'x)
                      5))
       (thunk* (test-case "unary minus" (fail))))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-int-side-effect)))
