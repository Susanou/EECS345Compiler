#lang racket

(provide interpret)

(require "../functional/either.rkt"
         "../machine/machine.rkt"
         "../machine/machine-update.rkt"
         "../parser/simpleParser.rkt"
         "../machine/binding.rkt"
         "../denotation/M-state.rkt"
         "../language/symbol/literal/bool.rkt")

(define null-thunk*
  (thunk* 'null))

(define (bool-token bool)
  (if bool
      TRUE
      FALSE))

(define transformers
  (hash 'BOOL bool-token
        'INT  values
        'NULL null-thunk*))

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
