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
         "mapping.rkt")

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
  (hash 'return (lambda (args state)
                  (let ([mapping (auto-type-binding-mapping (car args) state)])
                    (if (mapping-value? mapping)
                        (values (result-return
                                 (mapping-value-value mapping))
                                state)
                        (values (result-error (mapping-error-message mapping))
                                state))))
        'var    (lambda (args state)
                  (values
                   (result-void)
                   (machine-scope-bind state
                                       (first args)
                                       (if (< (length args) 2)
                                           (binding 'NULL null)
                                           (mapping-value-value
                                            (auto-type-binding-mapping (second args)
                                                                       state))))))
        '=      (lambda (args state)
                  (let ([name  (first  args)]
                        [value (second args)])
                    (if (machine-scope-bound? state name)
                        (values
                         (result-void)
                         (machine-scope-bind state
                                             name
                                             (mapping-value-value
                                              (auto-type-binding-mapping value
                                                                         state))))
                        (values (result-error (format "assign before declare: ~s"
                                                      name))
                                state))))
        'if     (lambda (args state)
                  (if (mapping-value-value (M-bool (first args) state))
                      (M-state (second args) state)
                      (if (>= (length args) 3)
                          (M-state (third args)  state)
                          (values  (result-void) state))))
        'while  (lambda (args state)
                  (if (mapping-value-value (M-bool (first args) state))
                      (let-values ([(body-result body-state)
                                    (M-state (second args) state)])
                        (if (result-void? body-result)
                            (M-state (cons 'while args) body-state)
                            (values body-result body-state)))
                      (values (result-void) state)))))
                      

(define (operation? expression)
  (and (pair? expression)
       (hash-has-key? operations (car expression))))

(define (operate expression state)
  ((hash-ref operations (car expression)) (cdr expression)
                                          state))

(define (M-state expression state)
  (if (operation? expression)
      (operate expression state)
      (values (result-void) state)))
