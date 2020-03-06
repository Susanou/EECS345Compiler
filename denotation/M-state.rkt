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
   RETURN   (lambda (args state return continue)
              (try (M-value (single-argument args) state)
                   (lambda (value)
                     (return value state))))

   DECLARE  (lambda (args state return continue)
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

   ASSIGN   (lambda (args state return continue)
              (let ([name  (left-argument  args)])
                (if (machine-bound-any? state name)
                    (try (M-value (right-argument args) state)
                         (lambda (value)
                           (success (machine-bind-current state
                                                          name
                                                          value))))
                    (failure (format "assign before declare: ~s"
                                     name)))))

   IF       (lambda (args state return continue)
              (try (M-bool (first-argument args) state)
                   (lambda (condition)
                     (if condition
                         (M-state (second-argument args)
                                  state
                                  return
                                  continue)
                         (if (triady-argument? args)
                             (M-state (third-argument args)
                                      state
                                      return
                                      continue)
                             (success state))))))

   WHILE    (lambda (args state return continue)
              (try (M-bool (left-argument args) state)
                   (lambda (condition)
                     (if condition
                         (try (let/cc c
                                (M-state (right-argument args)
                                         state
                                         return
                                         (lambda (state)
                                           (c (success state)))))
                              (lambda (state)
                                (M-state (single-expression WHILE args)
                                         state
                                         return
                                         continue)))
                         (success state)))))

   CONTINUE (lambda (args state return continue)
              (continue state))

   BLOCK    (lambda (args state return continue)
              (if (null? args)
                  (success state)
                  (try (M-state (first args)
                                state
                                return
                                continue)
                       (lambda (state)
                         (M-state (single-expression BLOCK (rest args))
                                  state
                                  return
                                  continue)))))

   BEGIN    (lambda (args state return continue)
              (try (M-state (single-expression BLOCK args)
                            (machine-scope-push state)
                            (lambda (value state)
                              (return value
                                      (machine-scope-pop state)))
                            continue)
                   (lambda (state)
                     (success (machine-scope-pop state)))))))

(define (operation exp state return continue)
  (let ([op (operator exp)])
    (if (hash-has-key? operations op)
        ((hash-ref     operations op) (arguments exp)
                                      state
                                      return
                                      continue)
        (failure "unrecognized operation"))))

(define no-return
  (thunk* (failure "unexpected return")))

(define no-continue
  (thunk* (failure "continue outside loop")))

(define (M-state
         exp
         state
         (return no-return)
         (continue no-continue))
  (if (EXPRESSION? exp)
      (operation exp
                 state
                 return
                 continue)
      (success state)))