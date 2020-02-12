#lang racket

(provide (struct-out result-void)
         (struct-out result-return)
         (struct-out result-error)
         machine-update
         machine-consume)

(require "machine-scope.rkt")

(struct result-void ()
  #:transparent)

(struct result-return (value)
  #:transparent)

(struct result-error (message)
  #:transparent)

(define operations
  (hash 'return (lambda (args state)
                  (values (result-return 0)
                          state))
        'var    (lambda (args state)
                  (values (result-void)
                          (machine-scope-bind state 'x 0)))
        '=      (lambda (args state)
                  (values (result-void)
                          state))))

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
      (values (result-void) state)
      (machine-update state (car statements))))
