#!/usr/bin/env racket

#lang racket

(require rackunit
         "interpreter.rkt"
         "examples-manifest.rkt")

(define/provide-test-suite
  test-interpreter
  (test-suite
   "examples"
   (for ([example examples-manifest])
     (test-case
      (example-name example)
      (check-equal? (interpret (example-file example))
                    (example-expected example))))))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-interpreter)))
