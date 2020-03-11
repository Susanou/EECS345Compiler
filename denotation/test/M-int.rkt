#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../M-int.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt")

(define/provide-test-suite 
  test-M-int
  (test-suite
   "integers"
   (test-equal? "zero"
                (M-int 0 null)
                (success 0))
   (test-equal? "fize"
                (M-int 5 null)
                (success 5))
   (test-equal? "negative three"
                (M-int -3 null)
                (success -3)))
  (test-suite
   "variables"
   (test-equal? "ok"
                (M-int 'x (machine-scope-bind (machine-new)
                                              'x
                                              3))
                (success 3))
   (test-equal? "wrong type"
                (M-int 'x (machine-scope-bind (machine-new)
                                              'x
                                              null))
                (failure "variable not INT: x"))
   (test-equal? "unbound"
                (M-int 'x (machine-new))
                (failure "use before bind: x")))
  (test-suite
   "expressions"
   (test-equal? "plus"
                (M-int '(+ 1 2) null)
                (success 3))
   (test-equal? "minus"
                (M-int '(- 1 2) null)
                (success -1))
   (test-equal? "multiply"
                (M-int '(* 5 2) null)
                (success 10))
   (test-equal? "divide"
                (M-int '(/ 5 2) null)
                (success 2))
   (test-equal? "mod"
                (M-int '(% 5 2) null)
                (success 1))
   (test-equal? "unary minus"
                (M-int '(- 5) null)
                (success -5))
   (test-equal? "6 * (8 + (5 % 3)) / 11 - 9"
                (M-int '(- (/ (* 6 (+ 8 (% 5 3))) 11) 9) (machine-new))
                (success -4)
                )))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-int)))
