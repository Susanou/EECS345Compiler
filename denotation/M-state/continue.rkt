#lang racket

(provide M-state-continue)

(define (M-state-continue args state return continue)
  (continue state))