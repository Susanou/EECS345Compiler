#lang racket

(provide M-state)

(require "mapping.rkt"
         "../machine/binding.rkt"
         "../machine/machine-scope.rkt"
         "M-int.rkt")

(define DEFAULT-BINDING (binding null null))

(define operations
  (hash 'var (lambda (args state)
               (mapping-value
                (machine-scope-bind state
                                    (car args)
                                    DEFAULT-BINDING)))
        '=   (lambda (args state)
               (mapping-value 
                (machine-scope-bind state
                                    (first args)
                                    (binding 'INT
                                             (mapping-value-value
                                              (M-int (second args) state))))))))

(define (operation? expression)
  (and (pair? expression)
       (hash-has-key? operations (car expression))))

(define (operate expression state)
  ((hash-ref operations (car expression)) (cdr expression)
                                          state))

(define (no-op state)
  (mapping-value state))

(define (M-state expression state)
  (if (operation? expression)
      (operate expression state)
      (no-op state)))
