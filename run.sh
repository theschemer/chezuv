#! /usr/bin/env scheme -q --debug-on-exception --libdirs vendor:.

;; (parameterize ([compile-profile 'source])
;;   (load "run.ss"))
(top-level-program (import  (uv) (chezscheme))
                   (define iterations 10)
                   (define display-http-request
                     (lambda (status headers body)
                       (format #t "[~a] Status: ~a\n" 0 status)
                       (for-each (lambda (h)
                                   (format #t "~a: ~a\n" (car h) (cadr h)))
                                 headers)
                       (newline)
                       (format #t "~a\n" (utf8->string body))))

                   (format #t "Running\n")
                   (time
                    (uv/with-loop
                     (lambda (loop)
                       (uv/call-with-ssl-context #f #f #t
                                                 (lambda (ctx)
                                                   (let ([rx 0]
                                                         [url (uv/string->url "https://google.ca")])
                                                     (let top ((n 0))
                                                       (format #t "top\n")
                                                       (let/async ([r (<- (uv/make-https-request loop ctx url))])
                                                                  (format #t "ok: ~a\n" r)
                                                                  (set! rx (+ 1 rx))
                                                                  (if (> rx iterations)
                                                                      (begin
                                                                        (apply display-http-request r)
                                                                        (format #t "iterations: ~a, rx: ~a\n" iterations rx)
                                                                        (exit))
                                                                      (top (+ 1 n))))))))))))
