#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-type.rkt")

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
                (mapping-value 'BOOL))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-type)))
