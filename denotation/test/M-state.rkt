#!/usr/bin/env racket

#lang racket

(require rackunit
         "../M-state.rkt"
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
                (machine-bound-any? state 'x))))
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
                    (result-return 0))))
    (test-suite
     "false"
     (let-values ([(result state)
                   (M-state '(if false (return 0) (return 1))
                            (machine-new))])
       (test-equal? "return properly"
                    result
                    (result-return 1)))))
   (test-suite
    "no else"
    (test-suite
     "true"
     (let-values ([(result state)
                   (M-state '(if true (return 0))
                            (machine-new))])
       (test-equal? "return properly"
                    result
                    (result-return 0))))
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
                   (machine-bound-any? state 'x))
       (test-false "y NOT bound"
                   (machine-bound-any? state 'y))))
    (test-suite
     "false"
     (let-values ([(result state)
                   (M-state '(if false (var x) (var y))
                            (machine-new))])
       (test-equal? "return properly"
                    result
                    (result-void))
       (test-false "x NOT bound"
                   (machine-bound-any? state 'x))
       (test-true  "y bound"
                   (machine-bound-any? state 'y))))))
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
                           (machine-bind-new (machine-new)
                                               'x
                                               #t))])
      (test-pred "result is void"
                 result-void?
                 result)
      (test-equal? "x is bound to false"
                   (machine-ref state 'x)
                   #f))))
  (test-suite
   "assign before declare"
   (let-values ([(result state)
                 (M-state '(= x 0)
                          (machine-new))])
     (test-equal? "state unchanged"
                  state
                  (machine-new))
     (test-equal? "result is error"
                  result
                  (result-error "assign before declare: x"))))
  (test-suite
   "return before declare"
   (let-values ([(result state)
                 (M-state '(return x) (machine-new))])
     (test-equal? "state unchanged"
                  state
                  (machine-new))
     (test-equal? "result is error"
                  result
                  (result-error "use before declare: x"))))
  (test-suite
   "assign from before declare"
   (let ([state (machine-bind-new (machine-new)
                                    'y
                                    null)])
     (let-values ([(result new-state)
                   (M-state '(= y x) state)])
       (test-equal? "state unchanged"
                    new-state
                    state)
       (test-equal? "result is error"
                    result
                    (result-error "use before declare: x"))))))
     
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-state)))
