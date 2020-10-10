(define (smallest-divisor n) ;find the smallest divisor of n
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n)
         n)
        ((divides? test-divisor n)
         test-divisor)
        (else (find-divisor
               n
               (+ test-divisor 1)))))
(define (divides? a b) ;b能否整除a
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

;199 true
;1999 true
;19999 false
