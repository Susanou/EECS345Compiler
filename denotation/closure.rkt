#lang racket

(provide (struct-out closure))

(struct closure (parameters body level)
  #:transparent)