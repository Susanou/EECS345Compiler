#lang racket

(provide M-state-break)

(define (M-state-break M-state
                       args
                       state
                       throw
                       return
                       continue
                       break)
  (break state))