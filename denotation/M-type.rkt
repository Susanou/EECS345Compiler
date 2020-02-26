#lang racket

(provide M-type)

(require "../functional/either.rkt"
         "../machine/machine-scope.rkt"
         "../machine/binding.rkt"
         "../language/expression.rkt"
         "../language/symbol/operator/bool.rkt"
         "../language/symbol/operator/comparison.rkt"
         "../language/symbol/operator/int.rkt"
         "../language/symbol/operator/variable.rkt"
         "../language/symbol/literal/bool.rkt"
         "../language/symbol/literal/int.rkt"
         "../language/symbol/variable.rkt")

(define (operator-expression-check operators)
  (lambda (expression)
    (and (pair? expression)
         (member (car expression)
                 operators))))

(define (variable-type-mapping name state)
  (if (machine-scope-bound? state name)
      (success (binding-type (machine-scope-ref state name)))
      (failure (format "use before declare: ~s"
                             name))))

(define TYPE-MAPPING-BOOL (success 'BOOL))
(define TYPE-MAPPING-INT  (success 'INT))

(define (M-type exp state)
  (if (EXPRESSION? exp)
      (let ([op   (operator   exp)]
            [args (arguments exp)])
        (cond [(or (BOOL-OPERATOR?      op)
                   (COMPARISON-OPERATOR?      op)) TYPE-MAPPING-BOOL               ]
              [(INT-OPERATOR?       op) TYPE-MAPPING-INT                ]
              [(eq? ASSIGN op) (M-type (right-argument args) state)]
              [else (failure "expression has no type")]))
      (cond [(BOOL? exp) TYPE-MAPPING-BOOL]
            [(INT?  exp) TYPE-MAPPING-INT ]
            [(VARIABLE?  exp) (variable-type-mapping exp state)])))