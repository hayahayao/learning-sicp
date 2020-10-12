;Simpson's Rule：一个更精确的求定积分的公式

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))
(define (integral f a b n)
  (define h (/ (- b a) n))
  (define (simpson-term k)
    (define y (f (+ a (* k h))))
    (cond ((or (= k 0) (= k n)) y)
          ((= (/ k 2) 0) (* 2 y))
          (else (* 4 y))))
  (define (inc k) (+ k 1))
  (* (/ h 3) (sum simpson-term 0 inc n)))
(define (cube x) (* x x x))

;(integral cube 0 1 100)
;9901/30000
;(integral cube 0 1 1000)
;999001/3000000
