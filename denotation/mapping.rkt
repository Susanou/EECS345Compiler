#lang racket

(provide (struct-out mapping-value)
         (struct-out mapping-error)
         MAPPING?
         map-bind)

(struct mapping-value (value)
  #:transparent)

(struct mapping-error (message)
  #:transparent)

(define (MAPPING? x)
  (or (mapping-value? x)
      (mapping-error? x)))

(define (map-bind mapping f (e null))
  (let ([result (if (mapping-value? mapping)
                      (f (mapping-value-value mapping))
                      mapping)])
    (if (mapping-value? result)
        result
        (if (null? e)
            result
            e))))