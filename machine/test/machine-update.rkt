#!/usr/bin/env racket

#lang racket

(require rackunit
         "../machine.rkt"
         "../machine-update.rkt")

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
                   (result-return 0))
      (test-equal? "state is unchanged"
                   state
                   (machine-new)))))
  (test-suite
   "consume"
   "(return 0)"
   (let-values ([(result state)
                 (machine-consume (machine-new) '((return 0)))])
     (test-equal? "result is return of zero"
                  result
                  (result-return 0))
     (test-equal? "state is unchanged"
                  state
                  (machine-new)))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-machine-update)))
