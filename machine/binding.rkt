#lang racket

(provide TYPE-NULL
         TYPE-INT
         TYPE-BOOL
         TYPES
         TYPE?
         (struct-out binding)
         BINDING-NULL)

(define TYPE-NULL 'NULL)
(define TYPE-INT  'INT)
(define TYPE-BOOL 'BOOL)

(define TYPES
  (set TYPE-NULL
       TYPE-INT
       TYPE-BOOL))

(define (TYPE? x)
  (set-member? TYPES x))

(define binding-types
  (hash TYPE-NULL (lambda (value)
                    (if (not (null? value))
                        (raise-argument-error 'value
                                              "null?"
                                              value)
                        (values 'NULL null)))
        TYPE-INT  (lambda (value)
                    (if (not (integer? value))
                        (raise-argument-error 'value
                                              "integer?"
                                              value)
                        (values 'INT value)))
        TYPE-BOOL (lambda (value)
                    (if (not (boolean? value))
                        (raise-argument-error 'value
                                              "boolean?"
                                              value)
                        (values 'BOOL value)))))

(define (bind-type type value)
  ((hash-ref binding-types type) value))

(struct binding (type value)
  #:transparent
  #:guard (lambda (type value name)
            (cond [(TYPE? type) (bind-type type value)]
                  [else         (raise-argument-error 'type
                                                      "binding-type?"
                                                      type)])))

(define BINDING-NULL (binding TYPE-NULL null))