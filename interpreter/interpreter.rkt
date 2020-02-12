#lang racket

(provide interpret
         (struct-out interpreter-value)
         (struct-out interpreter-error))

(require "../machine/machine.rkt"
         "../machine/machine-update.rkt"
         "../parser/simpleParser.rkt")

(struct interpreter-value (value)
  #:transparent)

(struct interpreter-error (message)
  #:transparent)

(define (interpret filename)
  (let-values ([(result state)
                (machine-consume (machine-new)
                                 (parser filename))])
    (if (result-return? result)
        (interpreter-value (result-return-value result))
        (interpreter-error (result)))))
