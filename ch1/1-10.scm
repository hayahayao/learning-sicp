(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y)
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1)))))))

(A 1 10)
(A 0 (A 1 9))
(A 0 (A 0 (A 1 8)))
;...
;观察规律，结果相当于 2^10=1024

(A 2 4)
(A 1 (A 2 3))
(A 1 (A 1 (A 2 2)))
(A 1 (A 1 (A 1 (A 2 1))))
(A 1 (A 1 (A 1 2)))
(A 1 (A 1 4))
(A 1 16)
;2^16=65536

(A 3 3)
(A 2 (A 3 2))
(A 2 (A 2 (A 3 1)))
(A 2 (A 2 2))
(A 2 (A 1 (A 2 1)))
(A 2 (A 1 2))
(A 2 4)
;65536

(define (f n) (A 0 n))
;2*n

(define (g n) (A 1 n))
;2^n

(define (h n) (A 2 n))
;(A 2 n)
;(A 1 (A 2 (- n 1)))
;(A 1 (A 1 (A 2 (- n 2))))
;...
;直到底部为 (A 2 (- n (- n 1))) 也就是 A(2 1)=2
;此时外面套了 n-1 个 (A 1 ...)
;所以需要一直乘下去
;2^...^2^2(n个)
