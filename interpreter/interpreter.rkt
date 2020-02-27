#lang racket

(provide interpret)

(require "../functional/either.rkt"
         "../language/symbol/types.rkt"
         "../language/symbol/literal/null.rkt"
         "../language/symbol/literal/bool.rkt"
         "../machine/binding.rkt"
         "../machine/machine.rkt"
         "../machine/machine-update.rkt"
         "../denotation/M-state.rkt"
         "../parser/simpleParser.rkt")

(define null-thunk*
  (thunk* NULL-VALUE))

(define (bool-token bool)
  (if bool
      TRUE
      FALSE))

(define transformers
  (hash BOOL      bool-token
        INT       values
        NULL-TYPE null-thunk*))

(define (transformer type)
  (hash-ref transformers type))

(define (transform type value)
  ((transformer type) value))

(define (return binding)
  (success (transform (binding-type  binding)
                      (binding-value binding))))

(define (interpret filename)
  (let-values ([(result _)
                (machine-consume (machine-new)
                                 (parser filename))])
    (cond [(result-return? result) (return  (result-return-value  result))]
          [else                    (failure (result-error-message result))])))
