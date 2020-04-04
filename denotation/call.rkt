#lang racket

(provide call)

(require "../functional/either.rkt"
         "../language/expression.rkt"
         "../language/symbol/operator/block.rkt"
         "../language/symbol/operator/variable.rkt"
         "../language/type.rkt"
         "../machine/machine-scope.rkt"
         "util.rkt"
         "closure.rkt")

(define (curry-arguments M-state
                         parameter-names
                         parameter-expressions
                         state)
  (if (null? parameter-names)
      (success state)
      (try (M-state (list DECLARE (first parameter-names) (first parameter-expressions))
                    state)
           (lambda (state)
             (curry-arguments M-state
                              (rest parameter-names)
                              (rest parameter-expressions)
                              state)))))

(define (M-call-state M-state
                      closure
                      state
                      parameter-expressions)
  (curry-arguments M-state
                   (closure-parameters closure)
                   parameter-expressions
                   (machine-scope-push state)))

(define (return-state state)
  (machine-scope-pop state))

(define (call M-state
              args
              state
              throw
              return
              fallthrough)
  (try (map-variable CLOSURE (first args) state)
       (lambda (closure)
         (let/cc r
           (try (M-call-state M-state
                              closure
                              state
                              (rest args))
                (lambda (call-state)
                  (try (M-state (single-expression BLOCK (closure-body closure))
                                call-state
                                throw
                                (lambda (value state)
                                  (r (return value
                                             (return-state state)))))
                       fallthrough)))))))