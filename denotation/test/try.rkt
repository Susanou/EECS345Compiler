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
                        (try ((= x 5)) () ()))
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
                        (try ((= x 5))
                             ()
                             (finally ((= y 6)))))
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
                        (try ((= x 5))
                             (catch (e) ((= y 6)))
                             ()))
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
                        (try ((= x 5))
                             (catch (e) ((= y 6)))
                             (finally ((= z 12)))))
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
                        (try ((= x 5)
                              (throw 8)
                              (= y 6))
                             ()
                             ()))
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
                        (try ((= x 5)
                              (throw 8)
                              (= y 6))
                             ()
                             (finally ((= z 7)))))
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
                        (try ((= x 5)
                              (throw 8)
                              (= y 6))
                             (catch (e) ((= z 7)))
                             ()))
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
                        (try ((= x 5)
                              (throw 8)
                              (= y 6))
                             (catch (e) ((= z 7)))
                             (finally ((= w 9)))))
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
                                (try ((continue))
                                     ()
                                     (finally ((= x 5)))))))
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
                                (try ((continue))
                                     ()
                                     (finally ((= x 5)))))))
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
                      (try ((return 7))
                           ()
                           (finally ((= x 5)))))
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
                                (try ((throw 0))
                                     (catch (e) (continue))
                                     (finally ((= x 5)))))))
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
                      (try ((throw 0))
                           (catch (e) ((return 7)))
                           (finally ((= x 5)))))
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
   "catch has cause bound"
   (on (M-state '(block (var x)
                        (try ((throw 8))
                             (catch (y)
                               ((= x y)))
                             ()))
                (machine-new))
       (lambda (state)
         (test-equal? "x set"
                      (machine-ref state 'x)
                      8))
       fail))
  (test-suite
   "catch has cause is evaluated"
   (on (M-state '(block (var x)
                        (var z)
                        (try ((throw (= z 4)))
                             (catch (y)
                               ((= x (* y 2))))
                             ()))
                (machine-new))
       (lambda (state)
         (test-suite
          "both"
          (test-equal? "x set"
                       (machine-ref state 'x)
                       8)
          (test-equal? "z set"
                       (machine-ref state 'z)
                       4)))
       fail))
  (test-suite
   "try catch and finally occur within begin scopes"
   (on (M-state '(block (var x)
                        (try ((var x))
                             (catch (e)
                               ((var x)
                                (throw 0)))
                             (finally
                              ((var x)))))
                (machine-new))
       (lambda (state) (void))
       fail)))
  
(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-try)))