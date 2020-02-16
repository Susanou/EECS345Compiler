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

(define (auto-type-binding value state)
  (let ([type (mapping-value-value (M-type value
                                           state))])
    (binding type
             (mapping-value-value
              ((hash-ref type-mappers type) value
                                            state)))))

(define operations
  (hash 'return (lambda (args state)
                  (values (result-return (auto-type-binding (car args)
                                                            state))
                          state))
        'var    (lambda (args state)
                  (values
                   (result-void)
                   (machine-scope-bind state
                                       (first args)
                                       (if (< (length args) 2)
                                           (binding 'NULL null)
                                           (auto-type-binding (second args)
                                                              state)))))
        '=      (lambda (args state)
                  (values
                   (result-void)
                   (machine-scope-bind state
                                       (first args)
                                       (auto-type-binding (second args)
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
