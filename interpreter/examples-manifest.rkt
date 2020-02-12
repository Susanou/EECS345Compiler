#lang racket

(provide examples-manifest
         (struct-out example))

(struct example (name file expected)
  #:transparent)

(require racket/runtime-path
         "interpreter.rkt")

(define-runtime-path EXAMPLES-DIR "examples/")

(define examples-manifest
  (list (example "return zero"
                 (build-path EXAMPLES-DIR
                             "return-zero.txt")
                 (interpreter-value 0))))
