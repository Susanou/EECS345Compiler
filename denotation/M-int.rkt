#lang racket

(provide M-int)

(require "mapping.rkt"
         "../machine/binding.rkt"
         "../machine/machine-scope.rkt")

(define (map-variable name state)
  (if (machine-scope-bound? state name)
      (let ([binding (machine-scope-ref state name)])
        (if (eq? 'INT (binding-type binding))
            (mapping-value (binding-value binding))
            (mapping-error (format "variable not integer: ~s"
                                   name))))
      (mapping-error (format "use before bind: ~s"
                             name))))

(define (binary-operation operator)
  (lambda (args state)
    (mapping-value
     (operator (mapping-value-value (M-int (first  args) state))
               (mapping-value-value (M-int (second args) state))))))

(define (unary-operation operator)
  (lambda (args state)
    (mapping-value
     (operator (mapping-value-value (M-int (first  args) state))))))

(define (unary-binary-operator unary binary)
  (lambda (args state)
    (if (< (length args) 2)
        (unary   args state)
        (binary  args state))))

(define operations
  (hash '+ (binary-operation +)
        '- (unary-binary-operator (unary-operation -)
                                  (binary-operation -))
        '/ (binary-operation quotient)
        '% (binary-operation remainder)
        '* (binary-operation *)))

(define (map-operation expression state)
  (if (hash-has-key? operations (first expression))
      ((hash-ref operations (first expression)) (rest expression) state)
      (mapping-error "unrecognized operation")))

(define (M-int expression state)
  (cond [(integer? expression) (mapping-value expression)]
        [(symbol?  expression) (map-variable  expression state)]
        [(list?    expression) (map-operation expression state)]
        [else                  (mapping-error "unrecognized expression")]))
