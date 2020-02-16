#lang racket

(provide M-bool)

(require  "mapping.rkt"
          "M-int.rkt"
          "../machine/machine-scope.rkt"
          "../machine/binding.rkt")

(define constants
  (hash 'true #t
        'false #f))

(define (constant? expression)
  (hash-has-key? constants expression))

(define (constant-mapping-value expression)
  (mapping-value (hash-ref constants expression)))

(define operations
  (hash
   '= (lambda (expression state)
          (M-bool (second expression) state))

   '! (lambda (expression state)
        (mapping-value
         (not (mapping-value-value
               (M-bool (car expression) state)))))
               
   '&& (lambda (args state)
          (mapping-value
            (and (mapping-value-value
                  (M-bool (car args) state)) 
                (mapping-value-value
                  (M-bool (cadr args) state)))))
                  
   '|| (lambda (args state)
            (mapping-value
              (or (mapping-value-value
                (M-bool (car args) state))
                  (mapping-value-value
                (M-bool (cadr args) state)))))

   '== (lambda (args state)
            (mapping-value
              (= (mapping-value-value
                (M-int (car args) state))
                  (mapping-value-value
                (M-int (cadr args) state)))))

   '!= (lambda (args state)
            (mapping-value
              (not (= (mapping-value-value
                (M-int (car args) state))
                  (mapping-value-value
                (M-int (cadr args) state))))))

    '>= (lambda (args state)
            (mapping-value
              (>= (mapping-value-value
                    (M-int (car args) state))
                  (mapping-value-value
                    (M-int (cadr args) state)))))

    '<= (lambda (args state)
            (mapping-value
              (<= (mapping-value-value
                    (M-int (car args) state))
                  (mapping-value-value
                    (M-int (cadr args) state)))))
                    
    '> (lambda (args state)
            (mapping-value
              (> (mapping-value-value
                    (M-int (car args) state))
                  (mapping-value-value
                    (M-int (cadr args) state)))))

    '< (lambda (args state)
            (mapping-value
              (< (mapping-value-value
                    (M-int (car args) state))
                  (mapping-value-value
                    (M-int (cadr args) state)))))))

(define (operation? expression)
  (and (list? expression)
       (hash-has-key? operations (car expression))))

(define (operation-mapping-value expression state)
  ((hash-ref operations (car expression)) (cdr expression) state))

(define (M-bool expression state)
  (cond
    [(constant?  expression) (constant-mapping-value  expression)]
    [(operation? expression) (operation-mapping-value expression state)]
    ((and (atom? expression) (machine-scope-bound? state expression) 
          (eq? (binding-type (machine-scope-ref state expression)) 'BOOL)) 
            (mapping-value (binding-value (machine-scope-ref state expression))))
    [else                    (mapping-error "unsupported")]))

(define atom?
  (lambda (x)
  (and (not (pair? x)) (not (null? x)))))