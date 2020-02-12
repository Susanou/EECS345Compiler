#!/usr/bin/env racket

#lang racket

(require rackunit
         "../machine.rkt"
         "../machine-scope.rkt")

(define/provide-test-suite
  test-machine-scope
  (let* ([empty-machine (machine-new)]
         [a-machine
          (machine-scope-bind empty-machine
                              'name
                              'a-value)]
         [b-machine
          (machine-scope-bind a-machine
                              'name
                              'b-value)])
    (test-false "empty machine does not have name in scope"
                (machine-scope-bound? empty-machine
                                      'name))
    (test-true "machine-A does have name in scope"
               (machine-scope-bound? a-machine
                                     'name))
    (test-equal? "machine-A has correct value bound to name"
                 (machine-scope-ref a-machine 'name)
                 'a-value)
    (test-false "machine-A does not have not-name in scope"
                (machine-scope-bound? a-machine
                                      'not-name))
    (test-true "machine-B does have name in scope"
               (machine-scope-bound? b-machine
                                     'name))
    (test-equal? "machine-B has correct value bound to name"
                 (machine-scope-ref b-machine 'name)
                 'b-value)
    (test-false "machine-B does not have not-name in scope"
                (machine-scope-bound? b-machine
                                      'not-name))))


(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-machine-scope)))
