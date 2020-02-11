#!/usr/bin/env racket

#lang racket

(require rackunit
         "parselib.rkt")

(define/provide-test-suite
  test-parser
  (check-equal? (parse "")
                null
                "empty parse")
  (check-equal? (parse "var x;")
                '((var x))
                "declare x")
  (check-equal? (parse (string-append
                        "var x;"
                        "var y = 3;"
                        "var z = 1;"
                        "x = y + z;"))
                '((var x)
                  (var y 3)
                  (var z 1)
                  (= x (+ y z)))
                (string-append
                 "declare x, y, and z, "
                 "assign values, "
                 "perform operations")))

(module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-parser)))
