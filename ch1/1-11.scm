;recursive
(define (f n)
  (if (< n 3)
      n
      (+ (f (- n 1)) (* 2 (f (- n 2))) (* 3 (f (- n 3))))))

;iterative
(define (f n)
  (f-iter 2 1 0 0 n))
(define (f-iter a b c i n) ;a b c 分别代表f(i+2) f(i+1) f(i)
  (if (= i n)
      c
      (f-iter (+ a (* 2 b) (* 3 c))
              a
              b
              (+ i 1)
              n)))
