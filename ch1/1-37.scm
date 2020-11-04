(define (cont-frac n d k)
  (define (cf i)
    (if (= i k)
        (/ (n i) (d i))
        (/ (n i) (+ (d i) (cf (+ i 1))))))
  (cf 1))

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           k)
;k=11 得到四位精确的 .6180555555555556

;迭代版
(define (cont-frac n d k)
  (define (iter i result)
    (if (= i 0)
        result
        (iter (- i 1)
              (/ (n i) (+ (d i) result))))
  (iter (- k 1)
        (/ (n k) (d k)))))
