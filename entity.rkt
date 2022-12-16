#lang racket

(require racket/serialize)

(provide Todo-entry)
(provide show)
(provide get-id)

(serializable-struct Todo-entry (id description))

(define (show x)
  (match x
    [(Todo-entry i d) (displayln (string-append (string-append (number->string i) " :  ") d))]
    [else (displayln x)])
  )

(define (get-id td)
  (match td
    [(Todo-entry id x) id])
  )
