#lang racket

(provide call)

(require "../functional/either.rkt"
         "../language/expression.rkt"
         "../language/symbol/operator/block.rkt"
         "../language/type.rkt"
         "../machine/machine-scope.rkt"
         "util.rkt"
         "closure.rkt")

(define (M-parameter-state-and-values M-state M-value expressions state throw)
  (if (null? expressions)
      (success (list state null))
      (try (M-value (first expressions) state M-state throw)
           (lambda (value)
             (try (M-state (first expressions) state)
                  (lambda (state)
                    (try (M-parameter-state-and-values M-state M-value (rest expressions) state throw)
                         (lambda (recursed)
                           (success (list (first recursed) (cons value (second recursed))))))))))))

(define (execution-state closure parameter-values state)
  (foldl (lambda (name value state)
           (machine-bind-new state name value))
         (machine-scope-push (machine-plane state (closure-level closure)))
         (closure-parameters closure)
         parameter-values))

(define (return-state caller yeild)
  (machine-rebase (machine-scope-pop yeild) caller))

(define (call M-state
              M-value
              args
              state
              throw
              return
              fallthrough)
  (try (map-variable CLOSURE (first args) state)
       (lambda (closure)
         (try (M-parameter-state-and-values M-state M-value (rest args) state return)
              (lambda (state-and-values)
                (let ([parameter-state  (first  state-and-values)]
                      [parameter-values (second state-and-values)])
                  (let/cc r
                    (try (M-state (single-expression BLOCK (closure-body closure))
                                  (execution-state closure parameter-values state)
                                  throw
                                  (lambda (value yeild-state)
                                    (r (return value
                                               (return-state parameter-state yeild-state)))))
                         (lambda (yeild-state)
                           (fallthrough (return-state parameter-state yeild-state)))))))))))