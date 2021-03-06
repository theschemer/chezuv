;; Copyright (c) 2009 Derick Eddington.  All rights reserved.
;; Licensed under an MIT-style license.  My license is in the file
;; named LICENSE from the original collection this file is distributed
;; with.  If this file is redistributed with some other collection, my
;; license must also be included.

(library (srfi s78 lightweight-testing compat)
  (export
    check:write)
  (import
    (rnrs)
    (only (core) pretty-print))

  (define check:write
    (case-lambda
      ((x) (check:write x (current-output-port)))
      ((x p)
       (pretty-print x p)
       (newline p))))
)
