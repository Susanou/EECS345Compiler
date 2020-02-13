#lang racket

(provide M-type)

(require "mapping.rkt")

(define (M-type expression state)
  (mapping-value 'INT))
