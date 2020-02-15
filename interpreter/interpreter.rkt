#lang racket

(provide interpret
         (struct-out interpreter-value)
         (struct-out interpreter-error))

(require "../machine/machine.rkt"
         "../machine/machine-update.rkt"
         "../parser/simpleParser.rkt"
         "../machine/binding.rkt")

(struct interpreter-value (value)
  #:transparent)

(struct interpreter-error (message)
  #:transparent)

(define interpreter-value-mapping
  (hash 'BOOL (lambda (value) (if value 'true 'false))
        'INT  values
        'NULL (thunk* 'null)))

(define (interpreter-value-of-result result)
  (let* ([binding (result-return-value result)]
         [type    (binding-type        binding)]
         [value   (binding-value       binding)])
    (interpreter-value ((hash-ref interpreter-value-mapping type) value))))

(define (interpret filename)
  (let-values ([(result state)
                (machine-consume (machine-new)
                                 (parser filename))])
    (cond [(result-return? result) (interpreter-value-of-result result)]
          [else                    (interpreter-error (result))])))
