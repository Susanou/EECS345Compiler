#lang racket

(provide EXPRESSION?
         FUNCTION-CALL-EXPRESSION?
         single-expression
         operator
         arguments
         single-argument?
         binary-argument?
         triady-argument?
         single-argument
         left-argument
         right-argument
         first-argument
         second-argument
         third-argument)

(require "symbol/operator.rkt")
(require "symbol/operator/function.rkt")

(define (EXPRESSION? x)
  (and (pair?               x)
       (OPERATOR? (operator x))))

(define (FUNCTION-CALL-EXPRESSION? x)
  (and (EXPRESSION? x)
       (eq? (operator x) FUNCTION-CALL)))

(define single-expression cons)

(define operator  first)
(define arguments rest )

(define arguments-length length)

(define (arguments-length=? args n)
  (= (arguments-length args) n))

(define (single-argument? args) (arguments-length=? args 1))
(define (binary-argument? args) (arguments-length=? args 2))
(define (triady-argument? args) (arguments-length=? args 3))

(define single-argument first )
  
(define left-argument   first )
(define right-argument  second)

(define first-argument  first )
(define second-argument second)
(define third-argument  third )