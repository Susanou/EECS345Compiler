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
         "../denotation/M-bool.rkt"
         "../denotation/M-state.rkt")

(struct result-void ()
  #:transparent)

(struct result-return (value)
  #:transparent)

(struct result-error (message)
  #:transparent)

; DUPLICATE CODE! vvvv from M-state
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
; ^^^^

(define (return-operation args state)
  (values (result-return (auto-type-binding (second args)
                                            state))
          state))

(define (machine-update state statement)
  (if (eq? (car statement) 'return)
      (return-operation statement state)
      (values (result-void)
              (mapping-value-value (M-state statement state)))))

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