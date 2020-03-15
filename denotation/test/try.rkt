#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt"
         "../M-state.rkt")

(define/provide-test-suite 
  test-try
  (test-suite
   "bare try"
   (on (M-state '(block (var x)
                        (try (= x 5)))
                (machine-new))
       (lambda (state)
         (test-equal? "body"
                      (machine-ref state 'x)
                      5))
       fail))
  (test-suite
   "finally runs after passthrough"
   (on (M-state '(block (var x)
                        (var y)
                        (try (= x 5)
                             (finally (= y 6))))
                (machine-new))
       (lambda (state)
         (test-equal? "body"
                      (machine-ref state 'x)
                      5)
         (test-equal? "finally"
                      (machine-ref state 'y)
                      6))
       fail))
  (test-suite
   "catch does not run after passthrough"
   (on (M-state '(block (var x)
                        (var y 2)
                        (try (= x 5)
                             (catch (= y 6))))
                (machine-new))
       (lambda (state)
         (test-equal? "body"
                      (machine-ref state 'x)
                      5)
         (test-equal? "catch"
                      (machine-ref state 'y)
                      2))
       fail))
  (test-suite
   "catch does not run after passthrough, but finally does"
   (on (M-state '(block (var x)
                        (var y 2)
                        (var z)
                        (try (= x 5)
                             (catch (= y 6))
                             (finally (= z 12))))
                (machine-new))
       (lambda (state)
         (test-equal? "body"
                      (machine-ref state 'x)
                      5)
         (test-equal? "catch"
                      (machine-ref state 'y)
                      2)
         (test-equal? "finally"
                      (machine-ref state 'z)
                      12))
       fail))
  (test-suite
   "bare try with throw"
   (on (M-state '(block (var x)
                        (var y 2)
                        (try (block (= x 5)
                                    (throw 8)
                                    (= y 6))))
                (machine-new))
       (lambda (state)
         (test-equal? "body ran before throw"
                      (machine-ref state 'x)
                      5)
         (test-equal? "body stopped after throw"
                      (machine-ref state 'y)
                      2))
       fail))
  (test-suite
   "finally runs after throw"
   (on (M-state '(block (var x)
                        (var y 2)
                        (var z)
                        (try (block (= x 5)
                                    (throw 8)
                                    (= y 6))
                             (finally (= z 7))))
                (machine-new))
       (lambda (state)
         (test-equal? "body ran before throw"
                      (machine-ref state 'x)
                      5)
         (test-equal? "body stopped after throw"
                      (machine-ref state 'y)
                      2)
         (test-equal? "finally ran"
                      (machine-ref state 'z)
                      7))
       fail))
  (test-suite
   "catch runs after throw"
   (on (M-state '(block (var x)
                        (var y 2)
                        (var z)
                        (try (block (= x 5)
                                    (throw 8)
                                    (= y 6))
                             (catch (= z 7))))
                (machine-new))
       (lambda (state)
         (test-equal? "body ran before throw"
                      (machine-ref state 'x)
                      5)
         (test-equal? "body stopped after throw"
                      (machine-ref state 'y)
                      2)
         (test-equal? "catch ran"
                      (machine-ref state 'z)
                      7))
       fail))
  (test-suite
   "catch and finally ran after throw"
   (on (M-state '(block (var x)
                        (var y 2)
                        (var z)
                        (var w)
                        (try (block (= x 5)
                                    (throw 8)
                                    (= y 6))
                             (catch (= z 7))
                             (finally (= w 9))))
                (machine-new))
       (lambda (state)
         (test-equal? "body ran before throw"
                      (machine-ref state 'x)
                      5)
         (test-equal? "body stopped after throw"
                      (machine-ref state 'y)
                      2)
         (test-equal? "catch ran"
                      (machine-ref state 'z)
                      7)
         (test-equal? "finally ran"
                      (machine-ref state 'w)
                      9))
       fail))
  (test-suite
   "finally runs after continue"
   (on (M-state '(block (var x)
                        (var r true)
                        (while r
                               (block
                                (= r false)
                                (try (continue)
                                     (finally (= x 5))))))
                (machine-new))
       (lambda (state)
         (test-equal? "finally ran"
                      (machine-ref state 'x)
                      5))
       fail))
  (test-suite
   "finally runs after continue"
   (on (M-state '(block (var x)
                        (var r true)
                        (while r
                               (block
                                (= r false)
                                (try (continue)
                                     (finally (= x 5))))))
                (machine-new))
       (lambda (state)
         (test-equal? "finally ran"
                      (machine-ref state 'x)
                      5))
       fail))
  (test-suite
   "finally runs after return"
   (let/cc c
     (M-state '(block (var x)
                      (try (return 7)
                           (finally (= x 5))))
              (machine-new)
              (lambda (cause state) (fail cause))
              (lambda (value state)
                (c (test-suite
                    "returned"
                    (test-equal? "return value"
                                 value
                                 7)
                    (test-equal? "finally ran"
                                 (machine-ref state 'x)
                                 5)))))
     (fail "never returned")))
  (test-suite
   "finally runs after continue (in catch)"
   (on (M-state '(block (var x)
                        (var r true)
                        (while r
                               (block
                                (= r false)
                                (try (throw 0)
                                     (catch continue)
                                     (finally (= x 5))))))
                (machine-new))
       (lambda (state)
         (test-equal? "finally ran"
                      (machine-ref state 'x)
                      5))
       fail))
  (test-suite
   "finally runs after return (in catch)"
   (let/cc c
     (M-state '(block (var x)
                      (try (throw 0)
                           (catch (return 7))
                           (finally (= x 5))))
              (machine-new)
              (lambda (cause state) (fail cause))
              (lambda (value state)
                (c (test-suite
                    "returned"
                    (test-equal? "return value"
                                 value
                                 7)
                    (test-equal? "finally ran"
                                 (machine-ref state 'x)
                                 5)))))
     (fail "never returned"))))
  
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-try)))
