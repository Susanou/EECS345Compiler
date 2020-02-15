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

(define operations
  (hash 'return (lambda (args state)
                  (let ([value (first args)])
                    (values (result-return
                             (binding (mapping-value-value
                                       (M-type value
                                               state))
                                      (mapping-value-value
                                       (M-int value
                                              state))))
                            state)))
        'var    (lambda (args state)
                  (values (result-void)
                          (machine-scope-bind state
                                              (first args)
                                              (binding 'NULL null))))
        '=      (lambda (args state)
                  (let* ([variable   (first args)]
                         [value      (second args)]
                         [value-type (mapping-value-value (M-type value state))])
                    (values (result-void)
                            (machine-scope-bind state
                                                variable
                                                (binding value-type
                                                         (mapping-value-value
                                                          ((case value-type
                                                             [(INT)  M-int]
                                                             [(BOOL) M-bool]) value state)))))))))

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