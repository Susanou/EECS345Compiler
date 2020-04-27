#lang racket

(provide interpret)

(require "../functional/either.rkt"
         "../language/type.rkt"
         "../language/expression.rkt"
         "../language/symbol/literal/null.rkt"
         "../language/symbol/literal/bool.rkt"
         "../language/symbol/operator/block.rkt"
         "../language/symbol/operator/function.rkt"
         "../machine/machine.rkt"
         "../denotation/M-state.rkt"
         "../denotation/M-value.rkt"
         "../parser/classparser.rkt")

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

(define (interpret filename)
  (let/cc t
    (let ([uncaught
           (lambda (message state)
             (t (failure (format "uncaught exception: ~a"
                                 message))))])
      (try (M-state (single-expression BLOCK (parser filename))
                    (machine-new)
                    uncaught)
           (lambda (state)
             (try (M-value (list FUNCTION-CALL ENTRY-FUNCTION)
                           state
                           M-state
                           uncaught)
                  (lambda (value)
                    (success (transform (type value) value)))))))))
