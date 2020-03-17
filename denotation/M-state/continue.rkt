#lang racket

(provide M-state-continue)

(define (M-state-continue M-state
                          args
                          state
                          throw
                          return
                          continue)
  (continue state))