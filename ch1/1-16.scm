;recursive
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n)
         (square (fast-expt b (/ n 2))))
        (else
         (* b (fast-expt b (- n 1))))))

;iterative
(define (fast-expt b n)
 (fe-iter b n 1))
(define (fe-iter a b n) ;a为上一步计算出的结果，需要继续累乘
 (cond ((= n 0) a)
       ((even? n)
        (fe-iter a (* b b) (/ n 2))) ;注意这里传的是a，解释见下
       (else
        (fe-iter (* a b) b (- n 1)))))

;a*b^n = a*(b^(n/2))^2 = a*(b^2)^(n/2)
;a*b^n = a*b*b^(n-1) = (a*b)*b^(n-1)
