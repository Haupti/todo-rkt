#lang racket/base

(require racket/file)
(require racket/match)
(require racket/serialize)
(require racket/list)

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

(define args (vector->list (current-command-line-arguments)))

(define memory-file-name "todos.td")

(define (out-todo-memory)
  (open-output-file memory-file-name #:exists 'append)
  )

(define (clear-todo-memory)
  (delete-file memory-file-name)
  )

(define (close out)
  (close-output-port out)
  )

(define (in-todo-memory)
  (cond
    [(not (file-exists? memory-file-name)) (list)] 
    [else (file->list memory-file-name)])
  )

(define (get-saved-todos) 
  (define in (in-todo-memory)) 
  (map deserialize in) 
  )

(define (add-todo todo)
  (save-todo-entry (Todo-entry (gen-id) todo)) 
  )

(define (save-todo-entry todo-entry)
  (define out (out-todo-memory))
  (writeln (serialize todo-entry) out)
  (close out) 
  )

(define (list-todos)
  (define in (in-todo-memory))
  (define (fn x) (show (deserialize x)))
  (for-each fn in)
  )

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

(define (delete-by-id id)
  (define number-id (string->number id))
  (define todos (get-saved-todos))
  (define (predicate x) (not (eq? (get-id x) number-id)))
  (clear-todo-memory)
  (define out (out-todo-memory))
  (for-each (lambda (x) (save-todo-entry x)) (filter predicate todos))
  (close out)
  )
  
(define (with-logging x)
  (show x)
  (cond
    [(list? x) (for-each show x)]
    [else x])
  )

(define (program)
  (match args
    [(list "list") (list-todos)]
    [(list "add" td) (add-todo td)]
    [(list "check" id) (delete-by-id id)]
    [else (displayln "no command matched. use --help to see options.")])
  )

(program)
