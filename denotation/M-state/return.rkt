#lang racket

(provide M-state-return)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../M-value.rkt")

(define (M-state-return M-state args state return continue)
  (try (M-value (single-argument args) state)
       (lambda (value)
         (return value state))))