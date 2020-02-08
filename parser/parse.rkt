#!/usr/bin/env racket

#lang racket

; takes filename as argument
; prints parse tree to standard output

(require "simpleParser.rkt")

(define filename
  (command-line #:args(filename) filename))

(parser filename)
