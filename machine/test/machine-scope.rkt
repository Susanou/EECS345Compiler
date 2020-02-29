#!/usr/bin/env racket

#lang racket

(require rackunit
         "../machine.rkt"
         "../machine-scope.rkt")

(define (test-state name state var top any value)
  (test-suite
   name
   (test-equal? "bound top"
                (machine-bound-top? state var)
                top)
   (test-equal? "bound any"
                (machine-bound-any? state var)
                any)
   (if (not (null? value))
       (test-equal? "bound value"
                    (machine-ref    state var)
                    value)
       (void))))

(define/provide-test-suite
  test-machine-scope
  (let* ([a (machine-new                )]
         [b (machine-bind-new     a 'x 1)]
         [c (machine-bind-current b 'x 2)]
         [d (machine-scope-push   c     )]
         [e (machine-bind-current d 'x 3)]
         [f (machine-bind-new     e 'x 4)]
         [g (machine-bind-current f 'x 5)]
         [h (machine-scope-pop    g     )])
    (test-suite
     "state"
     (test-state "a" a 'x #f #f null)
     (test-state "b" b 'x #t #t 1)
     (test-state "c" c 'x #t #t 2)
     (test-state "d" d 'x #f #t 2)
     (test-state "e" e 'x #f #t 3)
     (test-state "f" f 'x #t #t 4)
     (test-state "g" g 'x #t #t 5)
     (test-state "h" h 'x #t #t 3))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-machine-scope)))
