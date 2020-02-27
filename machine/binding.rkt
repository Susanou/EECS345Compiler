#lang racket

(provide (struct-out binding)
         BINDING-NULL)

(require "../language/type.rkt")

(define (binder test test-string type)
  (lambda (value)
    (if (test value)
        (values type value)
        (raise-argument-error 'value
                              test-string
                              value))))

(define binders
  (hash NULL-TYPE (binder null?    "null?"    NULL-TYPE)
        INT       (binder integer? "integer?" INT)
        BOOL      (binder boolean? "boolean?" BOOL)))

(define (TYPE? x)
  (hash-has-key? binders x))

(define (bind type value)
  ((hash-ref binders type) value))

(struct binding (type value)
  #:transparent
  #:guard (lambda (type value name)
            (if (TYPE? type)
                (bind  type value)
                (raise-argument-error 'type
                                      "binding-type?"
                                      type))))

(define BINDING-NULL (binding NULL-TYPE null))