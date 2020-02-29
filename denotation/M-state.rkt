#lang racket

(provide (struct-out result-void)
         (struct-out result-return)
         (struct-out result-error)
         M-state)

(require "../functional/either.rkt"
         "../language/expression.rkt"
         "../language/symbol/operator/control.rkt"
         "../language/symbol/operator/variable.rkt"
         "../language/symbol/operator/block.rkt"
         "../machine/machine-scope.rkt"
         "util.rkt"
         "M-bool.rkt"
         "M-value.rkt")

(struct result-void ()
  #:transparent)

(struct result-return (value)
  #:transparent)

(struct result-error (message)
  #:transparent)

(define (try-result x state f)
  (on x
      f
      (lambda (cause)
        (values (result-error cause)
                state))))

(define (try-void thx state f)
  (let-values ([(result state) (thx)])
    (if (result-void? result)
        (f state)
        (values result state))))

(define (void-and state)
  (values
   (result-void)
   state))

(define operations
  (hash
   RETURN  (lambda (args state)
             (try-result (M-value (single-argument args) state)
                         state
                         (lambda (value)
                           (values (result-return value)
                                   state))))
   DECLARE (lambda (args state)
             (let ([name (left-argument  args)])
               (if (machine-bound-top? state name)
                   (values (result-error (format "redefining: ~a"
                                                 name))
                           state)
                   (if (binary-argument? args)
                       (try-result (M-value (right-argument args) state)
                                   state
                                   (lambda (init)
                                     (void-and (machine-bind-new state
                                                                   name
                                                                   init))))
                       (values
                        (result-void)
                        (machine-bind-new state
                                            name
                                            null))))))
   ASSIGN  (lambda (args state)
             (let ([name  (left-argument  args)])
               (if (machine-bound-any? state name)
                   (try-result (M-value (right-argument args) state)
                               state
                               (lambda (value)
                                 (void-and (machine-bind-current state
                                                               name
                                                               value))))
                   (values (result-error (format "assign before declare: ~s"
                                                 name))
                           state))))
   IF      (lambda (args state)
             (try-result (M-bool (first-argument args) state)
                         state
                         (lambda (condition)
                           (if condition
                               (M-state (second-argument args) state)
                               (if (triady-argument? args)
                                   (M-state (third-argument args)  state)
                                   (void-and state))))))
   WHILE   (lambda (args state)
             (try-result (M-bool (left-argument args) state)
                         state
                         (lambda (condition)
                           (if condition
                               (let-values ([(result state)
                                             (M-state (right-argument args) state)])
                                 (if (result-void? result)
                                     (M-state (cons WHILE args) state)
                                     (values result state)))
                               (void-and state)))))
   BLOCK   (lambda (args state)
             (if (null? args)
                 (void-and state)
                 (let-values ([(result new-state)
                               (M-state (first args) state)])
                   (if (result-void? result)
                       (M-state (cons BLOCK (rest args)) new-state)
                       (values result new-state)))))))

(define (M-state exp state)
  (cond [(EXPRESSION? exp) (map-operation operations exp state)]
        [else              (void-and                     state)]))