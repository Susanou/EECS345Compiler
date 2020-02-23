#lang racket

(provide EXPRESSION?
         operator
         arguments
         left-argument
         right-argument
         single-argument)

(require "symbol/operator.rkt")

(define (EXPRESSION? x)
  (and (pair?               x)
       (OPERATOR? (operator x))))

(define operator        first        )
(define arguments       rest         )
(define left-argument   first        )
(define right-argument  second       )
(define single-argument left-argument)