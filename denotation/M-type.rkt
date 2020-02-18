#lang racket

(provide M-type)

(require "mapping.rkt"
         "../machine/machine-scope.rkt"
         "../machine/binding.rkt"
         "mapping-utilities.rkt"
         "language.rkt")

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
  (if (EXP? exp)
      (let ([op   (exp-op   exp)]
            [args (exp-args exp)])
        (cond [(BOOL-OP?      op) TYPE-MAPPING-BOOL               ]
              [(INT-OP?       op) TYPE-MAPPING-INT                ]
              [(eq? OP-ASSIGN op) (M-type (args-right args) state)]
              [else (mapping-error "expression has no type")]))
      (cond [(BOOL? exp) TYPE-MAPPING-BOOL]
            [(INT?  exp) TYPE-MAPPING-INT ]
            [(VAR?  exp) (variable-type-mapping exp state)])))