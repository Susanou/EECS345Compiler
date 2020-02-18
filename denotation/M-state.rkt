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
         "language.rkt"
         "mapping-utilities.rkt")

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

(define (auto-type-binding-mapping value state)
  (let ([mapping (M-type value state)])
    (if (mapping-value? mapping)
        (mapping-value 
         (let ([type (mapping-value-value mapping)])
           (binding type
                    (mapping-value-value
                     ((hash-ref type-mappers type) value
                                                   state)))))
        mapping)))

(define operations
  (hash OP-RETURN (lambda (args state)
                    (let ([mapping (auto-type-binding-mapping (car args) state)])
                      (if (mapping-value? mapping)
                          (values (result-return
                                   (mapping-value-value mapping))
                                  state)
                          (values (result-error (mapping-error-message mapping))
                                  state))))
        OP-DECLARE    (lambda (args state)
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
                                                        (auto-type-binding-mapping
                                                         (second args)
                                                         state))))))))
        OP-ASSIGN      (lambda (args state)
                         (let ([name  (first  args)]
                               [value (second args)])
                           (if (machine-scope-bound? state name)
                               (let ([mapping (auto-type-binding-mapping value state)])
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
        OP-IF     (lambda (args state)
                    (if (mapping-value-value (M-bool (first args) state))
                        (M-state (second args) state)
                        (if (>= (length args) 3)
                            (M-state (third args)  state)
                            (values  (result-void) state))))
        OP-WHILE  (lambda (args state)
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
  (cond [(and (EXP? exp)
              (STM-OP? (exp-op exp))) (map-operation operations exp state)]
        [else          (no-op state)]))