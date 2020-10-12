(define (filtered-accumulate filter combiner null-value term a next b)
  (if (> a b)
      null-value
      (let ((rest-terms (filtered-accumulate filter combine null-value term (next a) next b))))
      (if (filter a)
          (combiner (term a) rest-terms)
          rest-terms)))

(define (prime-sum a b)
  (filtered-accumulate prime? + 0 square a inc b))

(define (relatively-prime-product n)
  (filtered-accumulate relatively-prime? * 1 identity 1 inc n))