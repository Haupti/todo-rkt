#lang racket

(require racket/file)
(require racket/match)
(require racket/serialize)
(require racket/list)
(require "repository.rkt")
(require "entity.rkt")

(define args (vector->list (current-command-line-arguments)))

(define (add-todo todo)
  (save-todo-entry (Todo-entry (gen-id) todo)) 
  )

(define (list-todos)
  (define in (get-saved-todos))
  (define (fn x) (show x))
  (for-each fn in)
  )

(define (delete-by-id id)
  (define number-id (string->number id))
  (define todos (get-saved-todos))
  (define (predicate x) (not (eq? (get-id x) number-id)))
  (clear-todo-memory)
  (define filtered-todos (filter predicate todos))
  (for-each (lambda (x) (save-todo-entry x)) filtered-todos)
  (cond
    [(= (length todos) (length filtered-todos)) (displayln "nothing deleted")])
  )

(define (help)
  (displayln "'--help' shows this.")
  (displayln "'list' shows todos with id.")
  (displayln "'check <id>' removes and todo from list.")
  (displayln "'add <text>' adds a new todo to list.")
  )

(define (program)
  (match args
    [(list "list") (list-todos)]
    [(list "add" td) (add-todo td)]
    [(list "check" id) (delete-by-id id)]
    [(list "--help") (help)]
    [else (displayln "no command matched. use --help to see options.")])
  )

(program)
