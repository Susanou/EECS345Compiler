#lang racket

(provide binding-type?
         (struct-out binding))

(define binding-types
  (hash 'NULL (lambda (value)
                (if (not (null? value))
                    (raise-argument-error 'value
                                          "null?"
                                          value)
                    (values 'NULL null)))
        'INT  (lambda (value)
                (if (not (integer? value))
                    (raise-argument-error 'value
                                          "integer?"
                                          value)
                    (values 'INT value)))
        'BOOL (lambda (value)
                (if (not (boolean? value))
                    (raise-argument-error 'value
                                          "boolean?"
                                          value)
                    (values 'BOOL value)))))

(define (binding-type? x)
  (hash-has-key? binding-types x))

(define (bind-type type value)
  ((hash-ref binding-types type) value))

(struct binding (type value)
  #:transparent
  #:guard (lambda (type value name)
            (cond [(binding-type? type) (bind-type type value)]
                  [else (raise-argument-error 'type
                                              "binding-type?"
                                              type)])))