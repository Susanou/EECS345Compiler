#lang racket

(provide M-type)

(require "../functional/either.rkt"
         "../language/type.rkt"
         "../language/expression.rkt"
         "../language/symbol/variable.rkt"
         "../language/symbol/literal/int.rkt"
         "../language/symbol/literal/bool.rkt"
         "../language/symbol/operator/int.rkt"
         "../language/symbol/operator/bool.rkt"
         "../language/symbol/operator/comparison.rkt"
         "../language/symbol/operator/variable.rkt"
         "../machine/machine-scope.rkt")

; DUPLICATE CODE
(define (type value)
  (cond [(null?    value) NULL-TYPE]
        [(boolean? value) BOOL     ]
        [(integer? value) INT      ]))
; ==============

(define (type-of-variable name state)
  (if (machine-bound-any? state name)
      (success (type (machine-ref state name)))
      (failure (format "use before declare: ~s"
                       name))))

(define TYPE-MAPPING-BOOL (success 'BOOL))
(define TYPE-MAPPING-INT  (success 'INT))

(define (M-type exp state)
  (cond [(BOOL?       exp) TYPE-MAPPING-BOOL]
        [(INT?        exp) TYPE-MAPPING-INT ]
        [(VARIABLE?   exp) (type-of-variable exp state)]
        [(EXPRESSION? exp)
         (let ([op (operator exp)])
           (cond [(BOOL-OPERATOR?       op) TYPE-MAPPING-BOOL]
                 [(COMPARISON-OPERATOR? op) TYPE-MAPPING-BOOL]
                 [(INT-OPERATOR?        op) TYPE-MAPPING-INT ]
                 [(eq? ASSIGN           op) (M-type (right-argument (arguments exp))
                                                    state)]
                 [else                     (failure "operation not recognized")]))]
        [else (failure "expression not recognized")]))