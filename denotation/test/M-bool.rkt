#!/usr/bin/env racket

#lang racket

(require rackunit
         "../mapping.rkt"
         "../M-bool.rkt"
         "../../machine/binding.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/binding.rkt"
         "../../machine/machine.rkt")

(define MAPPING-TRUE  (mapping-value #t))
(define MAPPING-FALSE (mapping-value #f))
(define MAPPING-ERROR (mapping-error "unsupported"))

(define/provide-test-suite 
  test-M-bool
  (test-suite
   "constants"
   
   (test-case
    "false"
    (check-equal?
     (M-bool 'false null)
     MAPPING-FALSE
     "false maps to #f"))
   
   (test-case
    "true"
    (check-equal?
     (M-bool 'true null)
     MAPPING-TRUE
     "true maps to #t")))

  (test-suite
   "operations"

   (test-case
    "! true"
    (check-equal?
     (M-bool '(! true) null)
     MAPPING-FALSE))

   (test-case
    "! false"
    (check-equal?
     (M-bool '(! false) null)
     MAPPING-TRUE))

    (test-case
    "1 == 1"
    (check-equal?
      (M-bool '(== 1 1) null)
      MAPPING-TRUE))

    (test-case
    "1 == 0"
    (check-equal?
      (M-bool '(== 1 0) null)
      MAPPING-FALSE))  

    (test-case
    "1 != 0"
    (check-equal?
      (M-bool '(!= 1 0) null)
      MAPPING-TRUE)) 

    (test-case
    "0 != 0"
    (check-equal?
      (M-bool '(!= 0 0) null)
      MAPPING-FALSE))
      
    (test-case
    "true || false"
    (check-equal?
      (M-bool '(|| true false) null)
      MAPPING-TRUE))
    
    (test-case
    "false || false"
    (check-equal?
      (M-bool '(|| false false) null)
      MAPPING-FALSE))

    (test-case
    "true || true"
    (check-equal?
      (M-bool '(|| true true) null)
      MAPPING-TRUE))

    (test-case
    "false || true"
    (check-equal?
      (M-bool '(|| false true) null)
      MAPPING-TRUE))

    (test-case
    "1 > 0"
    (check-equal?
      (M-bool '(> 1 0) null)
      MAPPING-TRUE))

    (test-case
    "1 >= 0"
    (check-equal?
      (M-bool '(>= 1 0) null)
      MAPPING-TRUE  ))

    (test-case
    "0 >= 0"
    (check-equal?
      (M-bool '(>= 0 0) null)
      MAPPING-TRUE))

    (test-case
    "0 >= 1"
    (check-equal?
      (M-bool '(>= 0 1) null)
      MAPPING-FALSE))

    (test-case
    "0 > 1"
    (check-equal? 
      (M-bool '(>= 0 1) null)
      MAPPING-FALSE))

    
      ) 


  (test-suite
   "nested operations"

   (test-case
    "! ! true"
    (check-equal?
     (M-bool '(! (! true)) null)
     MAPPING-TRUE))

   (test-case
    "! ! false"
    (check-equal?
     (M-bool '(! (! false)) null)
     MAPPING-FALSE))  

    (test-case
    "!(1 == 1)"
    (check-equal?
      (M-bool '(! (== 1 1)) null)
      MAPPING-FALSE))

    (test-case
    "((1 > 0) && (0 <= 1))"
    (check-equal?
      (M-bool '(&& (> 1 0) (<= 0 1)) null)
      MAPPING-TRUE))
     
     
     )

     (test-suite
     "state operations"
     (let* ([state   (machine-scope-bind (machine-new) 'x (binding 'BOOL #t))]
                    [mapping (M-bool 'x state)])

          
      (check-equal?
        mapping
        MAPPING-TRUE))

      (let* ([state   (machine-scope-bind (machine-new) 'x (binding 'INT 3))]
                    [mapping (M-bool 'x state)])

          
      (check-equal?
        mapping
        MAPPING-ERROR)))
     
     )

 
 (module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-bool)))
