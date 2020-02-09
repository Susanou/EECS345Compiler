#!/usr/bin/env racket

#lang racket

(provide parse)

(require racket/runtime-path)

(define-runtime-path PARSER-SCRIPT "parse.sh")

(define (parse txt)
  (let-values
      ([(proc out in err)
        (subprocess #f
                    #f
                    (current-error-port)
                    PARSER-SCRIPT)])
    (begin
      (write-string txt in)
      (close-output-port in)
      (subprocess-wait proc)
      (close-output-port in)
      (cadr (read out)))))
