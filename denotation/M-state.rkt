#lang racket

(provide M-state)

(require "../functional/either.rkt"
         "../language/expression.rkt"
         "../language/symbol/operator/control.rkt"
         "../language/symbol/operator/variable.rkt"
         "../language/symbol/operator/block.rkt"
         "../machine/machine-scope.rkt"
         "M-bool.rkt"
         "M-value.rkt")

(define operations
  (hash
   RETURN  (lambda (args state return)
             (try (M-value (single-argument args) state)
                  (lambda (value)
                    (return value state))))

   DECLARE (lambda (args state return)
             (let ([name (left-argument  args)])
               (if (machine-bound-top? state name)
                   (failure (format "redefining: ~a" name))
                   (if (binary-argument? args)
                       (try (M-value (right-argument args) state)
                            (lambda (init)
                              (success (machine-bind-new state
                                                         name
                                                         init))))
                       (success (machine-bind-new state
                                                  name
                                                  null))))))

   ASSIGN  (lambda (args state return)
             (let ([name  (left-argument  args)])
               (if (machine-bound-any? state name)
                   (try (M-value (right-argument args) state)
                        (lambda (value)
                          (success (machine-bind-current state
                                                         name
                                                         value))))
                   (failure (format "assign before declare: ~s"
                                    name)))))

   IF      (lambda (args state return)
             (try (M-bool (first-argument args) state)
                  (lambda (condition)
                    (if condition
                        (M-state (second-argument args)
                                 state
                                 return)
                        (if (triady-argument? args)
                            (M-state (third-argument args)
                                     state
                                     return)
                            (success state))))))

   WHILE   (lambda (args state return)
             (try (M-bool (left-argument args) state)
                  (lambda (condition)
                    (if condition
                        (try (M-state (right-argument args)
                                      state
                                      return)
                             (lambda (state)
                               (M-state (single-expression WHILE args)
                                        state
                                        return)))
                        (success state)))))

   BLOCK   (lambda (args state return)
             (if (null? args)
                 (success state)
                 (try (M-state (first args) state return)
                      (lambda (state)
                        (M-state (single-expression BLOCK (rest args))
                                 state
                                 return)))))

   BEGIN   (lambda (args state return)
             (try (M-state (single-expression BLOCK args)
                           (machine-scope-push state)
                           (lambda (value state)
                             (return value
                                     (machine-scope-pop state))))
                  (lambda (state)
                    (success (machine-scope-pop state)))))))

(define (operation exp state return)
  (let ([op (operator exp)])
    (if (hash-has-key? operations op)
        ((hash-ref     operations op) (arguments exp) state return)
        (failure "unrecognized operation"))))

(define no-return
  (thunk* (failure "unexpected return")))

(define (M-state exp state (return no-return))
  (if (EXPRESSION? exp)
      (operation exp state return)
      (success state)))