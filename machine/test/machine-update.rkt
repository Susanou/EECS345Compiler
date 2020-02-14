#!/usr/bin/env racket

#lang racket

(require rackunit
         "../machine.rkt"
         "../machine-update.rkt"
         "../machine-scope.rkt"
         "../binding.rkt")

(define/provide-test-suite
  test-machine-update
  (test-suite
   "update"
   (test-suite
    "return 0;"
    (let-values ([(result state)
                  (machine-update (machine-new) '(return 0))])
      (test-equal? "result is return of zero"
                   result
                   (result-return (binding 'INT 0)))
      (test-equal? "state is unchanged"
                   state
                   (machine-new))))
   (test-suite
    "return 1;"
    (let-values ([(result state)
                  (machine-update (machine-new) '(return 1))])
      (test-equal? "result is return of one"
                   result
                   (result-return (binding 'INT 1)))))
   (test-suite
    "var x;"
    (let-values ([(result state)
                  (machine-update (machine-new) '(var x))])
      (test-equal? "result is void"
                   result
                   (result-void))
      (test-true "scope has x bound"
                 (machine-scope-bound? state 'x))
      (test-equal? "x is bound to null binding"
                   (machine-scope-ref state 'x)
                   (binding 'NULL null)))))
  (test-suite
   "consume"
   (test-suite
    "null"
    (let-values ([(result state)
                  (machine-consume (machine-new) null)])
      (test-equal? "result is void"
                   result
                   (result-void))
      (test-equal? "state is unchanged"
                   state
                   (machine-new))))
   (test-suite
    "(return 0)"
    (let-values ([(result state)
                  (machine-consume (machine-new) '((return 0)))])
      (test-equal? "result is return of zero"
                   result
                   (result-return (binding 'INT 0)))
      (test-equal? "state is unchanged"
                   state
                   (machine-new))))
   (test-suite
    "(var x)"
    (let-values ([(result state)
                  (machine-consume (machine-new) '((var x)))])
      (test-equal? "result is void"
                   result
                   (result-void))
      (test-true "scope has x bound"
                 (machine-scope-bound? state 'x))))
   (test-suite
    "(var x)(return 0)"
    (let-values ([(result state)
                  (machine-consume (machine-new) '((var x)
                                                   (return 0)))])
      (test-equal? "result is return 0"
                   result
                   (result-return (binding 'INT 0)))
      (test-true "scope has x bound"
                 (machine-scope-bound? state 'x))))
   (test-suite
    "(return 0)(var x)"
    (let-values ([(result state)
                  (machine-consume (machine-new) '((return 0)
                                                   (var x)))])
      (test-equal? "result is return 0"
                   result
                   (result-return (binding 'INT 0)))
      (test-false "scope does not have x bound"
                  (machine-scope-bound? state 'x))))
   (test-suite
    "(var x)(= x 1)"
    (let-values ([(result state)
                  (machine-consume (machine-new) '((var x)(= x 1)))])
      (test-equal? "result is void"
                   result
                   (result-void))
      (test-equal? "x is bound to 1"
                   (machine-scope-ref state 'x)
                   (binding 'INT 1))))
   (test-suite
    "(var x)(= x false)"
    (let-values ([(result state)
                  (machine-consume (machine-new) '((var x)(= x false)))])
      (test-equal? "result is void"
                   result
                   (result-void))
      (test-equal? "x is bound to false"
                   (machine-scope-ref state 'x)
                   (binding 'BOOL #f))))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-machine-update)))
