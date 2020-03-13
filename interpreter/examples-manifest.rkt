#lang racket

(provide examples-manifest
         (struct-out example))

(struct example (name file expected)
  #:transparent)

(require racket/runtime-path
         "../functional/either.rkt")

(define-runtime-path EXAMPLES-DIR "examples/")

(define provided-example-value-tests
  (append
   (map (lambda (p)
          (example (format "provided example (1) #~s" (first p))
                   (build-path EXAMPLES-DIR
                               "provided"
                               "1"
                               (number->string (first p)))
                   (success (second p))))
        '((1 150)
          (2 -4)
          (3 10)
          (4 16)
          (5 220)
          (6 5)
          (7 6)
          (8 10)
          (9 5)
          (10 -39)
          (15 true)
          (16 100)
          (17 false)
          (18 true)
          (19 128)
          (20 12)
          (21 30)
          ;(22 11)
          (23 1106)
          (24 12)
          (25 16)
          (26 72)
          ;(27 21)
          (28 164)
          ))
   (map (lambda (p)
          (example (format "provided example (2) #~s" (first p))
                   (build-path EXAMPLES-DIR
                               "provided"
                               "2"
                               (number->string (first p)))
                   (success (second p))))
        '(
          (1  20     )
          (2  164    )
          (3  32     )
          (4  2      )
          (6  25     )
          (7  21     )
          (8  6      )
          ;(9  -1     )
          ;(10 789    )
          ;(14 12     )
          ;(15 125    )
          ;(16 110    )
          ;(17 2000400)
          ;(18 101    )
          ;(20 21     )
          ))))

(define provided-example-error-tests
  (append
   (map (lambda (p)
          (example (format "provided example (1) [error] #~s" (first p))
                   (build-path EXAMPLES-DIR
                               "provided"
                               "1"
                               (number->string (first p)))
                   (failure (second p))))
        '((11 "assign before declare: y")
          (12 "use before declare: x")
          ;(13 "use before assign")
          (14 "redefining: x")
          ))
   (map (lambda (p)
          (example (format "provided example (2) [error] #~s" (first p))
                   (build-path EXAMPLES-DIR
                               "provided"
                               "2"
                               (number->string (first p)))
                   (failure (second p))))
        '(
          (5  "use before declare: min")
          (11 "use before declare: y")
          ;(12 "use before declare: a")
          ;(13 "break outside while")
          ;(19 "uncaught exception: 1")
          ))))

(define examples-manifest
  (append
   (list
    (example "return null"
             (build-path EXAMPLES-DIR
                         "return-null.txt")
             (success 'null))
    (example "return zero"
             (build-path EXAMPLES-DIR
                         "return-zero.txt")
             (success 0))
    (example "return false"
             (build-path EXAMPLES-DIR
                         "return-false.txt")
             (success 'false)))
   provided-example-value-tests
   provided-example-error-tests))
