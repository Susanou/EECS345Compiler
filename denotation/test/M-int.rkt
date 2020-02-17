#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-int.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt"
         "../../machine/binding.rkt")

(define/provide-test-suite 
  test-M-int
  (test-suite
   "integers"
   (test-equal? "zero"
                (M-int 0 null)
                (mapping-value 0))
   (test-equal? "fize"
                (M-int 5 null)
                (mapping-value 5))
   (test-equal? "negative three"
                (M-int -3 null)
                (mapping-value -3)))
  (test-suite
   "variables"
   (test-equal? "ok"
                (M-int 'x (machine-scope-bind (machine-new)
                                              'x
                                              (binding 'INT 3)))
                (mapping-value 3))
   (test-equal? "wrong type"
                (M-int 'x (machine-scope-bind (machine-new)
                                              'x
                                              (binding 'NULL null)))
                (mapping-error "variable not integer: x"))
   (test-equal? "unbound"
                (M-int 'x (machine-new))
                (mapping-error "use before bind: x")))
  (test-suite
   "expressions"
   (test-equal? "plus"
                (M-int '(+ 1 2) null)
                (mapping-value 3))
   (test-equal? "minus"
                (M-int '(- 1 2) null)
                (mapping-value -1))
   (test-equal? "divide"
                (M-int '(/ 5 2) null)
                (mapping-value 2))
   (test-equal? "mod"
                (M-int '(% 5 2) null)
                (mapping-value 1))
   (test-equal? "unary minus"
                (M-int '(- 5) null)
                (mapping-value -5))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-int)))
