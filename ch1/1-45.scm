(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (average-damp f)
  (lambda (x)
    (average x (f x))))

(define (repeated f n)
  (lambda (x)
    (if (= n 1)
        (f x)
        (f ((repeated f (- n 1)) x)))))

(define (power x n)
  (if (= n 1)
      x
      (* x (power x (- n 1)))))

(define (nth-root-damped x nth damp)
  (fixed-point
    ((repeated average-damp damp)
      (lambda (y) (/ x (power y (- nth 1)))))
    1.0))
