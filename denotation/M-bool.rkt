#lang racket

(provide M-bool)

(require "mapping.rkt")

(define constants
  (hash 'true #t
        'false #f))

(define (constant? expression)
  (hash-has-key? constants expression))

(define (constant-mapping-value expression)
  (mapping-value (hash-ref constants expression)))

(define operations
  (hash
   '! (lambda (expression state)
        (mapping-value
         (not (mapping-value-value
               (M-bool (car expression) state)))))))

(define (operation? expression)
  (and (list? expression)
       (hash-has-key? operations (car expression))))

(define (operation-mapping-value expression state)
  ((hash-ref operations (car expression)) (cdr expression) state))

(define (M-bool expression state)
  (cond
    [(constant?  expression) (constant-mapping-value  expression)]
    [(operation? expression) (operation-mapping-value expression state)]
    [else                    (mapping-error "unsupported")]))
