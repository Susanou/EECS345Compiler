#!/usr/bin/env racket

#lang racket

(require rackunit
         "../binding.rkt")

(define/provide-test-suite
  test-binding
  (test-suite
   "binding invariants"
   (test-suite
    "create binding for NULL"
    (let ([bound (binding 'NULL null)])
      (test-pred "bound is binding"
                 binding?
                 bound)
      (test-eq? "bound of type NULL"
                (binding-type bound)
                'NULL)
      (test-equal? "bound of value null"
                   (binding-value bound)
                   null)))
   (test-suite
    "create binding for integer"
    (let ([bound (binding 'INT 0)])
      (test-pred "bound is binding"
                 binding?
                 bound)
      (test-eq? "bound of type integer"
                (binding-type bound)
                'INT)
      (test-equal? "bound of value zero"
                   (binding-value bound)
                   0)))
   (test-suite
    "create binding for boolean"
    (let ([bound (binding 'BOOL #f)])
      (test-pred "bound is binding"
                 binding?
                 bound)
      (test-eq? "bound of type boolean"
                (binding-type bound)
                'BOOL)
      (test-equal? "bound of value zero"
                   (binding-value bound)
                   #f)))
   (test-suite
    "exception on creation of bad binding"
    (test-exn
     "bad type"
     exn:fail:contract?
     (thunk (binding null null)))
    (test-exn
     "bad null"
     exn:fail:contract?
     (thunk (binding 'NULL #t)))
    (test-exn
     "bad integer"
     exn:fail:contract?
     (thunk (binding 'INT .5)))
    (test-exn
     "bad boolean"
     exn:fail:contract?
     (thunk (binding 'BOOL 1))))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-binding)))
