#lang racket

(provide machine-consume)

(require "../denotation/M-state.rkt")

(define (machine-consume state statements)
  (if (null? statements)
      (values (result-void) state)
      (let-values ([(result new-state)
                    (M-state (car statements) state)])
        (if (result-void? result)
            (machine-consume new-state (cdr statements))
            (values result new-state)))))