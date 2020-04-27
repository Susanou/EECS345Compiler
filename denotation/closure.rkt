#lang racket

(provide (struct-out closure))
(provide (struct-out fclosure))

(struct closure (parameters body level)
  #:transparent)
  
(struct fclosure (parameters body level functclass)
   #:transparent)
