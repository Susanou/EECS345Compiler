#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../M-type.rkt"
         "../../machine/machine.rkt"
         "../../machine/machine-scope.rkt")

(define/provide-test-suite 
  test-M-type
  (test-suite
   "integer literals"
   (test-equal? "zero"
                (M-type 0 null)
                (success 'INT))
   (test-equal? "one"
                (M-type 1 null)
                (success 'INT)))
  (test-suite
   "integer operations"
   (test-equal? "+"
                (M-type '(+ this that) null)
                (success 'INT))
   (test-suite
    "boolean literals"
    (test-equal? "false"
                 (M-type 'false null)
                 (success 'BOOL))
    (test-equal? "true"
                 (M-type 'true null)
                 (success 'BOOL)))
   (test-equal? "||"
                (M-type '(|| this that) null)
                (success 'BOOL)))
  (test-suite
   "bound variable types"
   (let ([state (machine-bind-new
                 (machine-bind-new
                  (machine-bind-new
                   (machine-new)
                   'x
                   null)
                  'y
                  0)
                 'z
                 #f)])
     (test-equal? "type of x is NULL"
                  (M-type 'x state)
                  (success 'NULL))
     (test-equal? "type of y is INT"
                  (M-type 'y state)
                  (success 'INT))
     (test-equal? "type of z is BOOL"
                  (M-type 'z state)
                  (success 'BOOL))
     (test-equal? "type of w returns map error"
                  (M-type 'w state)
                  (failure "use before declare: w"))))
  (test-suite
   "assignments"
   (test-equal? "boolean"
                (M-type '(= x false) null)
                (success 'BOOL))
   (test-equal? "integer"
                (M-type '(= x 0) null)
                (success 'INT))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-type)))
