#lang racket

(provide (struct-out result-void)
         (struct-out result-return)
         (struct-out result-error)
         M-state)

(require "../machine/binding.rkt"
         "../machine/machine-scope.rkt"
         "M-int.rkt"
         "M-bool.rkt"
         "M-type.rkt"
         "../functional/either.rkt"
         "mapping-utilities.rkt"
         "M-binding.rkt"
         "../language/symbol/operator/control.rkt"
         "../language/symbol/operator/variable.rkt"
         "../language/expression.rkt")

(struct result-void ()
  #:transparent)

(struct result-return (value)
  #:transparent)

(struct result-error (message)
  #:transparent)

(define operations
  (hash CONTROL-RETURN (lambda (args state)
                         (on (M-binding (car args) state)
                              (lambda (value)
                                (values (result-return value)
                                        state))
                              (lambda (cause)
                                (values (result-error cause)
                                        state))))
        VARIABLE-DECLARE    (lambda (args state)
                              (let ([name  (first  args)])
                                (if (machine-scope-bound? state name)
                                    (values (result-error (format "redefining: ~a"
                                                                  name))
                                            state)
                                    (values
                                     (result-void)
                                     (machine-scope-bind state
                                                         name
                                                         (if (< (length args) 2)
                                                             (binding 'NULL null)
                                                             (success-value
                                                              (M-binding
                                                               (second args)
                                                               state))))))))
        VARIABLE-ASSIGN      (lambda (args state)
                               (let ([name  (first  args)]
                                     [value (second args)])
                                 (if (machine-scope-bound? state name)
                                     (on (M-binding value state)
                                          (lambda (value)
                                            (values
                                             (result-void)
                                             (machine-scope-bind state
                                                                 name
                                                                 value)))
                                          (lambda (cause)
                                            (values (result-error cause)
                                                    state)))
                                     (values (result-error (format "assign before declare: ~s"
                                                                   name))
                                             state))))
        CONTROL-IF     (lambda (args state)
                         (on (M-bool (first args) state)
                              (lambda (condition)
                                (if condition
                                    (M-state (second args) state)
                                    (if (>= (length args) 3)
                                        (M-state (third args)  state)
                                        (values  (result-void) state))))))
        CONTROL-WHILE  (lambda (args state)
                         (if (success-value (M-bool (first args) state))
                             (let-values ([(body-result body-state)
                                           (M-state (second args) state)])
                               (if (result-void? body-result)
                                   (M-state (cons 'while args) body-state)
                                   (values body-result body-state)))
                             (values (result-void) state)))))

(define (no-op state)
  (values (result-void) state))

(define (M-state exp state)
  (cond [(EXPRESSION? exp) (map-operation operations exp state)]
        [else       (no-op state)]))