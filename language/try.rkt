#lang racket

(provide CATCH
         FINALLY
         TRY-OPERATOR?
         try-body
         try-has-catch?
         try-catch-body
         try-has-finally?
         try-finally)

(require "symbol/operator/block.rkt")
(require "symbol/operator/variable.rkt")

(define CATCH   'catch  )
(define FINALLY 'finally)

(define OPERATORS
  (set CATCH
       FINALLY))

(define (TRY-OPERATOR? x)
  (set-member? OPERATORS x))

(define (try-body args)
  (cons BEGIN (first args)))

(define (has-arg getter args)
  (not (null? (getter args))))

(define (try-has-catch? args)
  (has-arg second args))

(define (try-has-finally? args)
  (has-arg third args))

(define (try-catch args)
  (rest (second args)))

(define (try-catch-bind args)
  (car (first (try-catch args))))
  
(define (try-catch-body args cause-value)
  (cons BEGIN
        (cons (cons DECLARE
                    (list (try-catch-bind args) cause-value))
              (second (try-catch args)))))

(define (try-finally args)
  (cons BEGIN
        (second (third args))))