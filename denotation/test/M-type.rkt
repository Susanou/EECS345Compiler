#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../M-state.rkt"
         "../M-type.rkt"
         "../../machine/machine.rkt"
         "../../machine/machine-scope.rkt")

; duplicate code
(define (uncaught-throw cause)
  (failure (format "uncaught exception: ~a"
                   cause)))
;

(define/provide-test-suite 
  test-M-type
  (test-suite
   "integer literals"
   (test-equal? "zero"
                (M-type 0 null M-state uncaught-throw)
                (success 'INT))
   (test-equal? "one"
                (M-type 1 null M-state uncaught-throw)
                (success 'INT)))
  (test-suite
   "integer operations"
   (test-equal? "+"
                (M-type '(+ this that) null M-state uncaught-throw)
                (success 'INT))
   (test-suite
    "boolean literals"
    (test-equal? "false"
                 (M-type 'false null M-state uncaught-throw)
                 (success 'BOOL))
    (test-equal? "true"
                 (M-type 'true null M-state uncaught-throw)
                 (success 'BOOL)))
   (test-equal? "||"
                (M-type '(|| this that) null M-state uncaught-throw)
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
                  (M-type 'x state M-state uncaught-throw)
                  (success 'NULL))
     (test-equal? "type of y is INT"
                  (M-type 'y state M-state uncaught-throw)
                  (success 'INT))
     (test-equal? "type of z is BOOL"
                  (M-type 'z state M-state uncaught-throw)
                  (success 'BOOL))
     (test-equal? "type of w returns map error"
                  (M-type 'w state M-state uncaught-throw)
                  (failure "use before declare: w"))))
  (test-suite
   "assignments"
   (test-equal? "boolean"
                (M-type '(= x false) null M-state uncaught-throw)
                (success 'BOOL))
   (test-equal? "integer"
                (M-type '(= x 0) null M-state uncaught-throw)
                (success 'INT))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-type)))
