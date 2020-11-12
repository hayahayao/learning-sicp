(define (for-each procduce items)
  (if (null? items)
      #t
      (and (procduce (car items))
           (for-each procdure (cdr items)))))
