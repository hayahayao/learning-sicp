(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs)) ;map!
            (accumulate-n op init (map cdr seqs)))))
