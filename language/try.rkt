#lang racket

(provide CATCH
         FINALLY
         TRY-OPERATOR?
         try-body
         try-has-catch?
         try-catch-bind
         try-catch-body
         try-has-finally?
         try-finally)

(require "symbol/operator/block.rkt")

(define CATCH   'catch  )
(define FINALLY 'finally)

(define OPERATORS
  (set CATCH
       FINALLY))

(define (TRY-OPERATOR? x)
  (set-member? OPERATORS x))

(define try-body first)

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
  
(define (try-catch-body args)
  (cons BLOCK (rest (try-catch args))))

(define (try-finally args)
  (second (last args)))