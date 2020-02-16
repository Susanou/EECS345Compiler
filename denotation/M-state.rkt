#lang racket

(provide M-state)

(require "mapping.rkt"
         "../machine/binding.rkt"
         "../machine/machine-scope.rkt"
         "M-int.rkt"
         "M-bool.rkt"
         "M-type.rkt")

(define type-mappers
  (hash 'INT  M-int
        'BOOL M-bool
        'NULL (thunk* (mapping-value null))))

(define (auto-type-binding value state)
  (let ([type (mapping-value-value (M-type value
                                           state))])
    (binding type
             (mapping-value-value
              ((hash-ref type-mappers type) value
                                            state)))))

(define operations
  (hash 'var    (lambda (args state)
                  (mapping-value
                   (machine-scope-bind state
                                       (first args)
                                       (if (< (length args) 2)
                                           (binding 'NULL null)
                                           (auto-type-binding (second args)
                                                              state)))))
        '=      (lambda (args state)
                  (let* ([variable   (first args)]
                         [value      (second args)])
                    (mapping-value
                     (machine-scope-bind state
                                         variable
                                         (auto-type-binding value state)))))))

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
