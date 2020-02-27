#lang racket

(provide (struct-out success)
         (struct-out failure)
         either?
         on
         try)

(struct success (value)
  #:transparent)

(struct failure (cause)
  #:transparent)

(define EITHER-TYPES
  (list success?
        failure?))

(define (either? x)
  (ormap (lambda (test) (test x))
         EITHER-TYPES))

(define (on x f (e failure))
  (cond [(success? x) (f (success-value x))]
        [(failure? x) (e (failure-cause x))]
        [else
         (raise-argument-error 'x
                               "either?"
                               x)]))

(define (try x f (e failure))
  (on (on x f)
      success
      e))