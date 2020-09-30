(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

;这个算法对于很小的数会计算出错误结果
(sqrt 0.0001)
;Value: .03230844833048122（而正确答案应该是0.01）

;对于很大的数则会陷入死循环
(sqrt 900000000000000000000000000000000000000000000000000000000000000000000000000000000000)
;正确答案应该是9.486832980505138e+41

;原因在于每次都要计算 (square guess)，当 guess 自身就过大/过小时平方后的结果直接爆了，导致后续结果都不对

;修改的办法是改变这个 good-enough? 的判断策略，不再以 guess^2 和 x 做比较
;而是比较新 guess 和老 guess 的差值，小于阈值就可以停止了
(define (good-enough? old-guess new-guess)
  (> 0.01
    (/ (abs (- new-guess old-guess))
       old-guess)))
