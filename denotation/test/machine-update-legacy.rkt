#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../../language/symbol/operator/block.rkt"
         "../../machine/machine.rkt"
         "../../machine/machine-scope.rkt"
         "../M-state.rkt")

; duplicate code
(struct result-void   ()        #:transparent)
(struct result-return (value)   #:transparent)
(struct result-error  (message) #:transparent)

(define (M-state-legacy exp state)
  (let/cc c
    (on (M-state exp
                 state
                 (thunk* (failure "legacy test: throw not supported"))
                 (lambda (v s)
                   (c (result-return v)
                      s)))
        (lambda (s)
          (values (result-void)
                  s))
        (lambda (m)
          (values (result-error m)
                  state)))))
; duplicate code

(define (machine-consume state statements)
  (M-state-legacy (cons BLOCK statements) state))

(define machine-scope-bound? machine-bound-any?)
(define machine-scope-ref    machine-ref)

(define/provide-test-suite
  test-machine-update-legacy
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
                   (result-return 0))
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
                   (result-return 0))
      (test-true "scope has x bound"
                 (machine-scope-bound? state 'x))))
   (test-suite
    "(return 0)(var x)"
    (let-values ([(result state)
                  (machine-consume (machine-new) '((return 0)
                                                   (var x)))])
      (test-equal? "result is return 0"
                   result
                   (result-return 0))
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
                   1)))
   (test-suite
    "(var x)(= x false)"
    (let-values ([(result state)
                  (machine-consume (machine-new) '((var x)(= x false)))])
      (test-equal? "result is void"
                   result
                   (result-void))
      (test-equal? "x is bound to false"
                   (machine-scope-ref state 'x)
                   #f)))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-machine-update-legacy)))
