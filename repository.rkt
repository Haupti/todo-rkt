#lang racket

(require racket/serialize)
(require "entity.rkt")

(provide clear-todo-memory)
(provide save-todo-entry)
(provide get-saved-todos)
(provide gen-id)

(define memory-file-name "todos.td")


;; delete all
(define (clear-todo-memory)
  (delete-file memory-file-name)
  )


;; save one
(define (save-todo-entry todo-entry)
  (define out (out-todo-memory))
  (writeln (serialize todo-entry) out)
  (close out) 
  )

(define (out-todo-memory)
  (open-output-file memory-file-name #:exists 'append)
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
    [(not (file-exists? memory-file-name)) (list)] 
    [else (file->list memory-file-name)])
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
