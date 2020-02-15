#lang racket

(provide examples-manifest
         (struct-out example))

(struct example (name file expected)
  #:transparent)

(require racket/runtime-path
         "interpreter.rkt")

(define-runtime-path EXAMPLES-DIR "examples/")

(define provided-example-value-tests
  (map (lambda (p)
         (example (format "provided example #~s" (first p))
                  (build-path EXAMPLES-DIR
                              "provided"
                              (number->string (first p)))
                  (interpreter-value (second p))))
       '((1 150)
         (2 -4)
         (3 10)
         (4 16)
         ;(5 220)
         ;(6 5)
         ;(7 6)
         ;(8 10)
         ;(9 5)
         (10 -39)
         ;(15 true)
         ;(16 100)
         ;(17 false)
         ;(18 true)
         ;(19 128)
         ;(20 12)
         ;(21 30)
         ;(22 11)
         ;(23 1106)
         ;(24 12)
         ;(25 16)
         ;(26 72)
         ;(27 21)
         ;(28 164)
         )))

(define provided-example-error-tests
  (map (lambda (p)
         (example (format "provided example [error] #~s" (first p))
                  (build-path EXAMPLES-DIR
                              "provided"
                              (number->string (first p)))
                  (interpreter-error (second p))))
       '(;(11 "using before declare")
         ;(12 "using before declare")
         ;(13 "use before assign")
         ;(14 "redefining")
         )))

(define examples-manifest
  (append
   (list
    (example "return null"
             (build-path EXAMPLES-DIR
                         "return-null.txt")
             (interpreter-value 'null))
    (example "return zero"
             (build-path EXAMPLES-DIR
                         "return-zero.txt")
             (interpreter-value 0))
    (example "return false"
             (build-path EXAMPLES-DIR
                         "return-false.txt")
             (interpreter-value 'false)))
   provided-example-value-tests
   provided-example-error-tests))
