#lang racket

(require racket/file)
(require racket/bool)

(provide memory-file-path)

;; can be modified
(define memory-file-name "todos.td")


;; do not modify
(define config-file-name "install-config")
(define install-config-exists (file-exists? config-file-name))


(define (get-configuration param)
  (define param= (string-append param "="))
  (define (trim-param str) (string-trim str param=))
  (define regex (regexp (string-append param= "[a-zA-Z\\/.0-9]+")))
  (cond 
    [install-config-exists (regexp-match regex (file->string config-file-name))]
    [else #f]
    )
  )

(define lib-path "lib-path")
(define maybe-path (get-configuration lib-path))

(define memory-file-path
  (cond
    [(string? maybe-path) (string-append maybe-path memory-file-name)]
    [(false? maybe-path) memory-file-name])
  )

