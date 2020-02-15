#lang racket

(provide (struct-out result-void)
         (struct-out result-return)
         (struct-out result-error)
         machine-update
         machine-consume)

(require "machine-scope.rkt"
         "binding.rkt"
         "../denotation/mapping.rkt"
         "../denotation/M-int.rkt"
         "../denotation/M-type.rkt"
         "../denotation/M-bool.rkt")

(struct result-void ()
  #:transparent)

(struct result-return (value)
  #:transparent)

(struct result-error (message)
  #:transparent)

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
  (hash 'return (lambda (args state)
                  (values (result-return (auto-type-binding (first args)
                                                            state))
                          state))
        'var    (lambda (args state)
                  (values (result-void)
                          (machine-scope-bind state
                                              (first args)
                                              (if (< (length args) 2)
                                                  (binding 'NULL null)
                                                  (auto-type-binding (second args)
                                                                     state)))))
        '=      (lambda (args state)
                  (let* ([variable   (first args)]
                         [value      (second args)])
                    (values (result-void)
                            (machine-scope-bind state
                                                variable
                                                (auto-type-binding value state)))))))
(define (operation? statement)
  (and (pair? statement)
       (hash-has-key? operations
                      (car statement))))

(define (operate statement state)
  ((hash-ref operations (car statement)) (cdr statement)
                                         state))

(define (machine-update state statement)
  (cond [(operation? statement) (operate statement state)]
        [else                   (result-error "undefined operation")]))

(define (machine-consume state statements)
  (if (null? statements)
      (values (result-void)
              state)
      (let-values ([(result new-state)
                    (machine-update state
                                    (car statements))])
        (cond [(result-return? result) (values result
                                               new-state)]
              [(result-error?  result) (values result
                                               new-state)]
              [else                    (machine-consume new-state
                                                        (cdr statements))]))))