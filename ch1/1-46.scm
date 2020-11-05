;iterative improvement:
;为了计算一个东西，先给一个初始猜测值，然后不断计算新的猜测值并检验，直到误差小于阈值
(define (iterative-improve good-enough? improve-guess)
  (define (iter guess)
    (if (good-enough? guess)
        guess
        (iter (improve-guess guess))))
  (lambda (guess) (iter guess)))
