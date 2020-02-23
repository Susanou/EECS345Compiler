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
         "mapping.rkt"
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
                    (let ([mapping (M-binding (car args) state)])
                      (if (mapping-value? mapping)
                          (values (result-return
                                   (mapping-value-value mapping))
                                  state)
                          (values (result-error (mapping-error-message mapping))
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
                                                       (mapping-value-value
                                                        (M-binding
                                                         (second args)
                                                         state))))))))
        VARIABLE-ASSIGN      (lambda (args state)
                         (let ([name  (first  args)]
                               [value (second args)])
                           (if (machine-scope-bound? state name)
                               (let ([mapping (M-binding value state)])
                                 (if (mapping-value? mapping)
                                     (values
                                      (result-void)
                                      (machine-scope-bind state
                                                          name
                                                          (mapping-value-value
                                                           mapping)))
                                     (values (result-error (mapping-error-message mapping))
                                             state)))
                               (values (result-error (format "assign before declare: ~s"
                                                             name))
                                       state))))
        CONTROL-IF     (lambda (args state)
                    (if (mapping-value-value (M-bool (first args) state))
                        (M-state (second args) state)
                        (if (>= (length args) 3)
                            (M-state (third args)  state)
                            (values  (result-void) state))))
        CONTROL-WHILE  (lambda (args state)
                    (if (mapping-value-value (M-bool (first args) state))
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