#!/usr/bin/env racket

#lang racket

(provide parse)

(require racket/runtime-path)

(define-runtime-path PARSER-SCRIPT "parse.sh")

(define ERROR-PORT
  (let ([current (current-error-port)])
    (if (file-stream-port? current)
        current
        #f)))

(define (parse txt)
  (let-values
      ([(proc out in err)
        (subprocess #f
                    #f
                    ERROR-PORT
                    PARSER-SCRIPT)])
    (begin
      (write-string txt in)
      (close-output-port in)
      (subprocess-wait proc)
      (close-output-port in)
      (cadr (read out)))))
