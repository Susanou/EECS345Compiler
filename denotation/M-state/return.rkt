#lang racket

(provide M-state-return)

(require "../../functional/either.rkt"
         "../../language/expression.rkt"
         "../M-value.rkt")

(define (M-state-return M-state
                        args
                        state
                        throw
                        return
                        continue
                        break)
  (try (M-value (single-argument args)
                state
                M-state
                throw)
       (lambda (value)
         (return value state))))