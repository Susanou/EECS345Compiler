#!/usr/bin/env racket

#lang racket

(provide parse)

(define (parse txt)
  (let-values
      ([(proc out in err)
        (subprocess #f
                    #f
                    (current-error-port)
                    "parse.sh")])
    (begin
      (write-string txt in)
      (close-output-port in)
      (subprocess-wait proc)
      (close-output-port in)
      (cadr (read out)))))
