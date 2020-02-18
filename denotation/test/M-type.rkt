#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-type.rkt"
         "../../machine/machine.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/binding.rkt")

(define/provide-test-suite 
  test-M-type
  (test-suite
   "integer literals"
   (test-equal? "zero"
                (M-type 0 null)
                (mapping-value 'INT))
   (test-equal? "one"
                (M-type 1 null)
                (mapping-value 'INT)))
  (test-suite
   "integer operations"
   (test-equal? "+"
                (M-type '(+ this that) null)
                (mapping-value 'INT))
   (test-suite
    "boolean literals"
    (test-equal? "false"
                 (M-type 'false null)
                 (mapping-value 'BOOL))
    (test-equal? "true"
                 (M-type 'true null)
                 (mapping-value 'BOOL)))
   (test-equal? "||"
                (M-type '(|| this that) null)
                (mapping-value 'BOOL)))
  (test-suite
   "bound variable types"
   (let ([state (machine-scope-bind
                 (machine-scope-bind
                  (machine-scope-bind
                   (machine-new)
                   'x
                   (binding 'NULL null))
                  'y
                  (binding 'INT 0))
                 'z
                 (binding 'BOOL #f))])
     (test-equal? "type of x is NULL"
                  (M-type 'x state)
                  (mapping-value 'NULL))
     (test-equal? "type of y is INT"
                  (M-type 'y state)
                  (mapping-value 'INT))
     (test-equal? "type of z is BOOL"
                  (M-type 'z state)
                  (mapping-value 'BOOL))
     (test-equal? "type of w returns map error"
                  (M-type 'w state)
                  (mapping-error "use before declare: w"))))
  (test-suite
   "assignments"
   (test-equal? "boolean"
                (M-type '(= x false) null)
                (mapping-value 'BOOL))
   (test-equal? "integer"
                (M-type '(= x 0) null)
                (mapping-value 'INT))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-type)))
