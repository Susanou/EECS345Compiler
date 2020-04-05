#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../M-int.rkt"
         "../M-state.rkt"
         "../M-value.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt")

; duplicate code
(define (uncaught-throw cause)
  (failure (format "uncaught exception: ~a"
                   cause)))
;

(define/provide-test-suite 
  test-M-int
  (test-suite
   "integers"
   (test-equal? "zero"
                (M-int 0 null M-state M-value uncaught-throw)
                (success 0))
   (test-equal? "fize"
                (M-int 5 null M-state M-value uncaught-throw)
                (success 5))
   (test-equal? "negative three"
                (M-int -3 null M-state M-value uncaught-throw)
                (success -3)))
  (test-suite
   "variables"
   (test-equal? "ok"
                (M-int 'x
                       (machine-bind-new (machine-new)
                                         'x
                                         3)
                       M-state M-value uncaught-throw)
                (success 3))
   (test-equal? "wrong type"
                (M-int 'x
                       (machine-bind-new (machine-new)
                                         'x
                                         null)
                       M-state M-value uncaught-throw)
                (failure "variable not INT: x"))
   (test-equal? "unbound"
                (M-int 'x (machine-new) M-state M-value uncaught-throw)
                (failure "use before bind: x")))
  (test-suite
   "expressions"
   (test-equal? "plus"
                (M-int '(+ 1 2) null M-state M-value uncaught-throw)
                (success 3))
   (test-equal? "minus"
                (M-int '(- 1 2) null M-state M-value uncaught-throw)
                (success -1))
   (test-equal? "multiply"
                (M-int '(* 5 2) null M-state M-value uncaught-throw)
                (success 10))
   (test-equal? "divide"
                (M-int '(/ 5 2) null M-state M-value uncaught-throw)
                (success 2))
   (test-equal? "mod"
                (M-int '(% 5 2) null M-state M-value uncaught-throw)
                (success 1))
   (test-equal? "unary minus"
                (M-int '(- 5) null M-state M-value uncaught-throw)
                (success -5))
   (test-equal? "6 * (8 + (5 % 3)) / 11 - 9"
                (M-int '(- (/ (* 6 (+ 8 (% 5 3))) 11) 9) (machine-new) M-state M-value uncaught-throw)
                (success -4)
                )))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-int)))
