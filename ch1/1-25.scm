;origin expmod
;(((a^n) mod m) * a) mod m = (a^(n+1)) mod m
;((a^n) mod m)^2 mod m = (a^(2n)) mod m
(define (expmod base exp m) ;calculate (base^exp) mod m
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder
          (square (expmod base (/ exp 2) m))
          m))
        (else
         (remainder
          (* base (expmod base (- exp 1) m))
          m))))
(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))
(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n)
         (fast-prime? n (- times 1)))
        (else false)))

;Alyssa P.Hacker's expmod
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n)
         (square (fast-expt b (/ n 2))))
        (else
         (* b (fast-expt b (- n 1))))))
(define (expmod base exp m)
  (remainder (fast-expt base exp) m))

;后一种解法理论上是没错的
;但因为没有即时取模可能会导致算到一半就溢出
