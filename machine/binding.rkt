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
                    (if (null? value)
                        (values TYPE-NULL null)
                        (raise-argument-error 'value
                                              "null?"
                                              value)))
        
        TYPE-INT  (lambda (value)
                    (if (integer? value)
                        (values TYPE-INT value)
                        (raise-argument-error 'value
                                              "integer?"
                                              value)))
        
        TYPE-BOOL (lambda (value)
                    (if (boolean? value)
                        (values TYPE-BOOL value)
                        (raise-argument-error 'value
                                              "boolean?"
                                              value)))))

(define (bind-type type value)
  ((hash-ref binding-types type) value))

(struct binding (type value)
  #:transparent
  #:guard (lambda (type value name)
            (if (TYPE? type)
                (bind-type type value)
                (raise-argument-error 'type
                                      "binding-type?"
                                      type))))

(define BINDING-NULL (binding TYPE-NULL null))