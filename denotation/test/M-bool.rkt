#!/usr/bin/env racket

#lang racket

(require rackunit
         "../../functional/either.rkt"
         "../M-state.rkt"
         "../M-value.rkt"
         "../M-bool.rkt"
         "../../machine/machine-scope.rkt"
         "../../machine/machine.rkt")

(define MAPPING-TRUE  (success #t))
(define MAPPING-FALSE (success #f))
(define MAPPING-ERROR (failure "unsupported"))

; duplicate code
(define (uncaught-throw cause)
  (failure (format "uncaught exception: ~a"
                   cause)))
;

(define/provide-test-suite 
  test-M-bool
  (test-suite
   "constants"
   
   (test-case
    "false"
    (check-equal?
     (M-bool 'false null M-state M-value uncaught-throw)
     MAPPING-FALSE
     "false maps to #f"))
   
   (test-case
    "true"
    (check-equal?
     (M-bool 'true null M-state M-value uncaught-throw)
     MAPPING-TRUE
     "true maps to #t")))

  (test-suite
   "operations"

   (test-case
    "! true"
    (check-equal?
     (M-bool '(! true) null M-state M-value uncaught-throw)
     MAPPING-FALSE))

   (test-case
    "! false"
    (check-equal?
     (M-bool '(! false) null M-state M-value uncaught-throw)
     MAPPING-TRUE))

    (test-case
    "1 == 1"
    (check-equal?
      (M-bool '(== 1 1) null M-state M-value uncaught-throw)
      MAPPING-TRUE))

    (test-case
    "1 == 0"
    (check-equal?
      (M-bool '(== 1 0) null M-state M-value uncaught-throw)
      MAPPING-FALSE))  

    (test-case
    "1 != 0"
    (check-equal?
      (M-bool '(!= 1 0) null M-state M-value uncaught-throw)
      MAPPING-TRUE)) 

    (test-case
    "0 != 0"
    (check-equal?
      (M-bool '(!= 0 0) null M-state M-value uncaught-throw)
      MAPPING-FALSE))
      
    (test-case
    "true || false"
    (check-equal?
      (M-bool '(|| true false) null M-state M-value uncaught-throw)
      MAPPING-TRUE))
    
    (test-case
    "false || false"
    (check-equal?
      (M-bool '(|| false false) null M-state M-value uncaught-throw)
      MAPPING-FALSE))

    (test-case
    "true || true"
    (check-equal?
      (M-bool '(|| true true) null M-state M-value uncaught-throw)
      MAPPING-TRUE))

    (test-case
    "false || true"
    (check-equal?
      (M-bool '(|| false true) null M-state M-value uncaught-throw)
      MAPPING-TRUE))

    (test-case
    "1 > 0"
    (check-equal?
      (M-bool '(> 1 0) null M-state M-value uncaught-throw)
      MAPPING-TRUE))

    (test-case
    "1 >= 0"
    (check-equal?
      (M-bool '(>= 1 0) null M-state M-value uncaught-throw)
      MAPPING-TRUE  ))

    (test-case
    "0 >= 0"
    (check-equal?
      (M-bool '(>= 0 0) null M-state M-value uncaught-throw)
      MAPPING-TRUE))

    (test-case
    "0 >= 1"
    (check-equal?
      (M-bool '(>= 0 1) null M-state M-value uncaught-throw)
      MAPPING-FALSE))

    (test-case
    "0 > 1"
    (check-equal? 
      (M-bool '(>= 0 1) null M-state M-value uncaught-throw)
      MAPPING-FALSE))

    
      ) 


  (test-suite
   "nested operations"

   (test-case
    "! ! true"
    (check-equal?
     (M-bool '(! (! true)) null M-state M-value uncaught-throw)
     MAPPING-TRUE))

   (test-case
    "! ! false"
    (check-equal?
     (M-bool '(! (! false)) null M-state M-value uncaught-throw)
     MAPPING-FALSE))  

    (test-case
    "!(1 == 1)"
    (check-equal?
      (M-bool '(! (== 1 1)) null M-state M-value uncaught-throw)
      MAPPING-FALSE))

    (test-case
    "((1 > 0) && (0 <= 1))"
    (check-equal?
      (M-bool '(&& (> 1 0) (<= 0 1)) null M-state M-value uncaught-throw)
      MAPPING-TRUE))
     
     
     )

     (test-suite
     "state operations"
     (let* ([state   (machine-bind-new (machine-new) 'x #t)]
                    [mapping (M-bool 'x state M-state M-value uncaught-throw)])

          
      (check-equal?
        mapping
        MAPPING-TRUE))

      (let* ([state   (machine-bind-new (machine-new) 'x 3)]
                    [mapping (M-bool 'x state M-state M-value uncaught-throw)])

          
      (check-equal?
        mapping
        (failure "variable not BOOL: x")))
        
      (check-equal?
        (M-bool '(= x (= y true)) (machine-new) M-state M-value uncaught-throw)
        MAPPING-TRUE
        )
        )
     
     )

 
 (module+ main
  (require rackunit/text-ui)
  (exit (run-tests test-M-bool)))
