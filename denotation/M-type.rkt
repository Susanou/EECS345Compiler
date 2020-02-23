#lang racket

(provide M-type)

(require "mapping.rkt"
         "../machine/machine-scope.rkt"
         "../machine/binding.rkt"
         "mapping-utilities.rkt"
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
      (mapping-value (binding-type (machine-scope-ref state name)))
      (mapping-error (format "use before declare: ~s"
                             name))))

(define TYPE-MAPPING-BOOL (mapping-value 'BOOL))
(define TYPE-MAPPING-INT  (mapping-value 'INT))

(define (M-type exp state)
  (if (EXPRESSION? exp)
      (let ([op   (operator   exp)]
            [args (arguments exp)])
        (cond [(or (BOOL-OPERATOR?      op)
                   (COMPARISON-OPERATOR?      op)) TYPE-MAPPING-BOOL               ]
              [(INT-OPERATOR?       op) TYPE-MAPPING-INT                ]
              [(eq? VARIABLE-ASSIGN op) (M-type (right-argument args) state)]
              [else (mapping-error "expression has no type")]))
      (cond [(BOOL? exp) TYPE-MAPPING-BOOL]
            [(INT?  exp) TYPE-MAPPING-INT ]
            [(VARIABLE?  exp) (variable-type-mapping exp state)])))