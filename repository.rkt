#lang racket

(require racket/serialize)
(require "entity.rkt")
(require "config.rkt")

(provide clear-todo-memory)
(provide save-todo-entry)
(provide get-saved-todos)
(provide gen-id)


;; delete all
(define (clear-todo-memory)
  (delete-file memory-file-path)
  )


;; save one
(define (save-todo-entry todo-entry)
  (define out (out-todo-memory))
  (writeln (serialize todo-entry) out)
  (close out)
  )

(define (out-todo-memory)
  (open-output-file memory-file-path #:exists 'append)
  )

(define (close out)
  (close-output-port out)
  )


;;get all
(define (get-saved-todos)
  (define in (in-todo-memory))
  (map deserialize in)
  )

(define (in-todo-memory)
  (cond
    [(not (file-exists? memory-file-path)) (list)]
    [else (file->list memory-file-path)])
  )


;; id generation
(define (gen-id)
  (get-next-id (get-saved-todos))
  )

(define (get-next-id todos)
  (define ids (map (lambda (x) (match x ([Todo-entry a b] a))) todos))
  (define sorted (sort ids >))
  (cond
    [(eq? (length sorted) 0) 1]
    [else (+ (first sorted) 1)])
  )
