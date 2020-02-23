#lang racket

(provide VARIABLE?)

(require "reserved.rkt")

(define (VARIABLE? x)
  (and (symbol?        x)
       (not (RESERVED? x))))