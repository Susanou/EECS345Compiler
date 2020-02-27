#lang racket

(provide (struct-out result-void)
         (struct-out result-return)
         (struct-out result-error)
         M-state)

(require "../functional/either.rkt"
         "../language/expression.rkt"
         "../language/symbol/operator/control.rkt"
         "../language/symbol/operator/variable.rkt"
         "../machine/binding.rkt"
         "../machine/machine-scope.rkt"
         "util.rkt"
         "M-bool.rkt"
         "M-binding.rkt")

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

(define (void-and state)
  (values
   (result-void)
   state))

(define operations
  (hash RETURN  (lambda (args state)
                  (try-result (M-binding (single-argument args) state)
                              state
                              (lambda (value)
                                (values (result-return value)
                                        state))))
        
        DECLARE (lambda (args state)
                  (let ([name (left-argument  args)])
                    (if (machine-scope-bound? state name)
                        (values (result-error (format "redefining: ~a"
                                                      name))
                                state)
                        (if (binary-argument? args)
                            (try-result (M-binding (right-argument args) state)
                                        state
                                        (lambda (init)
                                          (void-and (machine-scope-bind state
                                                                        name
                                                                        init))))
                            (values
                             (result-void)
                             (machine-scope-bind state
                                                 name
                                                 BINDING-NULL))))))
        
        ASSIGN  (lambda (args state)
                  (let ([name  (left-argument  args)])
                    (if (machine-scope-bound? state name)
                        (try-result (M-binding (right-argument args) state)
                                    state
                                    (lambda (value)
                                      (void-and (machine-scope-bind state
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
                  (if (success-value (M-bool (left-argument args) state))
                      (let-values ([(body-result body-state)
                                    (M-state (right-argument args) state)])
                        (if (result-void? body-result)
                            (M-state (cons WHILE args) body-state)
                            (values body-result body-state)))
                      (void-and state)))))

(define (M-state exp state)
  (cond [(EXPRESSION? exp) (map-operation operations exp state)]
        [else              (void-and                     state)]))