#lang racket

(provide interpret)

(require "../functional/either.rkt"
         "../language/type.rkt"
         "../language/expression.rkt"
         "../language/symbol/literal/null.rkt"
         "../language/symbol/literal/bool.rkt"
         "../language/symbol/operator/block.rkt"
         "../machine/machine.rkt"
         "../denotation/M-state.rkt"
         "../parser/simpleParser.rkt")

(define null-thunk*
  (thunk* NULL-VALUE))

(define (bool-token bool)
  (if bool
      TRUE
      FALSE))

(define transformers
  (hash NULL-TYPE null-thunk*
        BOOL      bool-token
        INT       values))

(define (transform type value)
  ((hash-ref transformers type) value))

; DUPLICATE CODE
(define (type value)
  (cond [(null?    value) NULL-TYPE]
        [(boolean? value) BOOL     ]
        [(integer? value) INT      ]))
; ==============

(define (return value)
  (success (transform (type value) value)))

(define (interpret filename)
  (let/cc r
    (on (M-state (single-expression BLOCK (parser filename))
                 (machine-new)
                 (lambda (value state)
                   (r (return value))))
        (thunk* (return null)))))