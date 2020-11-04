(define (d i)
  (cond ((= 0 (remainder (+ i 1) 3)) 
         (* 2 (/ (+ i 1) 3)))
        (else 1)))

(define (cont-frac n d k)
  (define (cf i)
    (if (= i k)
        (/ (n i) (d i))
        (/ (n i) (+ (d i) (cf (+ i 1))))))
  (cf 1))

(cont-frac (lambda (i) 1.0) d k)

;k=10 .7182817182817183
;+2，得到 e 约为 2.7182817182817183
