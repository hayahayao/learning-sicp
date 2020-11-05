(define (repeated f n)
  (lambda (x)
    (if (= n 1)
        (f x)
        (f ((repeated f (- n 1)) x)))))

(define (square x) (* x x))
((repeated square 2) 5) ;625

;use compose
(define (compose f g)
  (lambda (x) (f (g x))))
(define (repated f n)
  (lambda (x)
    (if (= n 1)
        f
        (compose f (repeated f (- n 1))))))
