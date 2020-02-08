#lang racket

(provide (struct-out mapping-value)
         (struct-out mapping-error))

(struct mapping-value (value))

(struct mapping-error (message))
