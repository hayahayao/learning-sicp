(define (double f)
  (lambda (x)
    (f (f x))))

(define (inc x) (+ x 1))

(((double (double double)) inc) 5)
;21
;2^(2^2)次inc
