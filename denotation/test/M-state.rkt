#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-state.rkt"
         "../../machine/binding.rkt"
         "../../machine/machine.rkt"
         "../../machine/machine-scope.rkt")

(define/provide-test-suite 
  test-M-state
  (test-suite
   "state unchanged by interger constant"
   (let-values ([(result state)
                 (M-state 0 (machine-new))])
     (test-pred "result is void"
                result-void?
                result)
     (test-equal? "state unchanged"
                  state
                  (machine-new))))
  (test-suite
   "state has variable after var expression"
   (let-values ([(result state)
                 (M-state '(var x) (machine-new))])
     (test-pred "result is void"
                result-void?
                result)
     (test-true "variable bound"
                (machine-scope-bound? state 'x))))
  (test-suite
   "if statement"
   (test-suite
    "return"
    (test-suite
     "true"
     (let-values ([(result state)
                   (M-state '(if true (return 0) (return 1))
                            (machine-new))])
       (test-equal? "return properly"
                    result
                    (result-return (binding 'INT 0)))))
    (test-suite
     "false"
     (let-values ([(result state)
                   (M-state '(if false (return 0) (return 1))
                            (machine-new))])
       (test-equal? "return properly"
                    result
                    (result-return (binding 'INT 1))))))
   (test-suite
    "no else"
    (test-suite
     "true"
     (let-values ([(result state)
                   (M-state '(if true (return 0))
                            (machine-new))])
       (test-equal? "return properly"
                    result
                    (result-return (binding 'INT 0)))))
    (test-suite
     "false"
     (let-values ([(result state)
                   (M-state '(if false (return 0))
                            (machine-new))])
       (test-equal? "return properly"
                    result
                    (result-void)))))
   (test-suite
    "bind"
    (test-suite
     "true"
     (let-values ([(result state)
                   (M-state '(if true (var x) (var y))
                            (machine-new))])
       (test-equal? "return properly"
                    result
                    (result-void))
       (test-true  "x bound"
                   (machine-scope-bound? state 'x))
       (test-false "y NOT bound"
                   (machine-scope-bound? state 'y))))
    (test-suite
     "false"
     (let-values ([(result state)
                   (M-state '(if false (var x) (var y))
                            (machine-new))])
       (test-equal? "return properly"
                    result
                    (result-void))
       (test-false "x NOT bound"
                   (machine-scope-bound? state 'x))
       (test-true  "y bound"
                   (machine-scope-bound? state 'y))))))
  (test-suite
   "while"
   (test-suite
    "body never runs"
    (let-values ([(result state)
                  (M-state '(while false (return 0)) (machine-new))])
      (test-pred "result is void"
                 result-void?
                 result)))
   (test-suite
    "body returns"
    (let-values ([(result state)
                  (M-state '(while true (return 0)) (machine-new))])
      (test-pred "result is return"
                 result-return?
                 result)))
   (test-suite
    "run once"
    (let-values ([(result state)
                  (M-state '(while x (= x false))
                           (machine-scope-bind (machine-new)
                                               'x
                                               (binding 'BOOL #t)))])
      (test-pred "result is void"
                 result-void?
                 result)
      (test-equal? "x is bound to false"
                   (machine-scope-ref state 'x)
                   (binding 'BOOL #f))))))
     
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-state)))
