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

(define (try-has-operator? operator args)
  (ormap (lambda (x)
           (eq? (first x) operator))
         (rest args)))

(define (try-has-catch? args)
  (try-has-operator? CATCH   args))

(define (try-has-finally? args)
  (try-has-operator? FINALLY args))

(define (try-catch args)
  (rest (if (try-has-finally? args)
            (second args)
            (last   args))))

(define (try-catch-bind args)
  (car (first (try-catch args))))
  
(define (try-catch-body args cause-value)
  (cons BEGIN
        (cons (cons DECLARE
                    (list (try-catch-bind args) cause-value))
              (second (try-catch args)))))

(define (try-finally args)
  (cons BEGIN
        (second (last args))))