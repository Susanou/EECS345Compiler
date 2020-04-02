#lang racket

(provide call)

(require "../functional/either.rkt"
         "../language/expression.rkt"
         "../language/symbol/operator/block.rkt"
         "../language/type.rkt"
         "util.rkt"
         "closure.rkt")

(define (call M-state args state throw return fallthrough)
  (try (map-variable CLOSURE (first-argument args) state)
       (lambda (closure)
         (let/cc r
           (try (M-state (single-expression BLOCK (closure-body closure))
                         state
                         throw
                         (lambda (value state) (r (return value state))))
                fallthrough)))))