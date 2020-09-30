(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))

(test 0 (p))

(if (= 0 0)
  0
  (p))

;applicative-order 立即求值，所以会陷入死循环
;normal-order 需要时才去求值，所以会返回0
