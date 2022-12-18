#lang racket

(require racket/file)
(require racket/bool)

(provide memory-file-path)
(define memory-file-name "todos.td")
(define memory-file-path (string-append (getenv "HOME") (string-append "/todo-rkt/" memory-file-name)))
