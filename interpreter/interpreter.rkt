#lang racket

(provide interpret)

(require "../functional/either.rkt"
         "../language/type.rkt"
         "../language/symbol/literal/null.rkt"
         "../language/symbol/literal/bool.rkt"
         "../language/symbol/operator/block.rkt"
         "../machine/binding.rkt"
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

(define (return binding)
  (success (transform (binding-type  binding)
                      (binding-value binding))))

(define (interpret filename)
  (let-values ([(result _)
                (M-state (cons BLOCK (parser filename))
                         (machine-new))])
    (cond [(result-return? result) (return  (result-return-value  result))]
          [else                    (failure (result-error-message result))])))
