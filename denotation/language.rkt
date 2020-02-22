#lang racket

(provide TRUE
         FALSE
         BOOLS
         BOOL?
         OP-NOT
         OP-OR
         OP-AND
         OP-EQ
         OP-NEQ
         OP-LTE
         OP-GTE
         OP-LT
         OP-GT
         BOOL-OPS
         BOOL-OP?
         OP-ADD
         OP-SUB
         OP-MUL
         OP-DIV
         OP-MOD
         INT-OPS
         INT-OP?
         OP-ASSIGN
         OP-IF      
         OP-WHILE   
         OP-RETURN  
         OP-DECLARE 
         STM-OPS
         STM-OP?
         OPS
         OP?
         RESERVED
         RESERVED?
         EXP?
         VAR?
         INT?
         exp-op
         exp-args
         args-single
         args-left
         args-right)

(define (f-member-of-set s)
  (lambda (x)
    (set-member? s x)))

(define TRUE  'true)
(define FALSE 'false)

(define BOOLS
  (set TRUE
       FALSE))

(define BOOL? (f-member-of-set BOOLS))

(define OP-NOT '! )
(define OP-OR  '||)
(define OP-AND '&&)
(define OP-EQ  '==)
(define OP-NEQ '!=)
(define OP-LTE '<=)
(define OP-GTE '>=)
(define OP-LT  '< )
(define OP-GT  '> )

(define BOOL-OPS
  (set OP-NOT   
       OP-OR    
       OP-AND   
       OP-EQ  
       OP-NEQ 
       OP-LTE 
       OP-GTE 
       OP-LT  
       OP-GT))

(define BOOL-OP? (f-member-of-set BOOL-OPS))

(define OP-ADD '+)
(define OP-SUB '-)
(define OP-MUL '*)
(define OP-DIV '/)
(define OP-MOD '%)

(define INT-OPS
  (set OP-ADD
       OP-SUB
       OP-MUL
       OP-DIV
       OP-MOD))

(define INT-OP? (f-member-of-set INT-OPS))

(define OP-ASSIGN  '=)
(define OP-IF      'if)
(define OP-WHILE   'while)
(define OP-RETURN  'return)
(define OP-DECLARE 'var)

(define STM-OPS
  (set OP-ASSIGN
       OP-IF
       OP-WHILE
       OP-RETURN
       OP-DECLARE))

(define STM-OP? (f-member-of-set STM-OPS))

(define OPS
  (set-union BOOL-OPS
             INT-OPS
             STM-OPS))

(define OP? (f-member-of-set OPS))

(define RESERVED
  (set-union BOOLS
             OPS
             STM-OPS))

(define RESERVED? (f-member-of-set RESERVED))

(define (EXP? x)
  (and (pair? x)
       (OP? (exp-op x))))
           
(define (VAR? x)
  (and (symbol? x)
       (not (RESERVED? x))))

(define INT? integer?)

(define exp-op   first)
(define exp-args rest)

(define args-single first)
(define args-left   first)
(define args-right  second)