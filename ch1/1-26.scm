;origin expmod
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder
          (square (expmod base (/ exp 2) m))
          m))
        (else
         (remainder
          (* base (expmod base (- exp 1) m))
          m))))

;Louis's expmod
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder
          (* (expmod base (/ exp 2) m)
             (expmod base (/ exp 2) m)) ;here!
          m))
        (else
         (remainder
          (* base (expmod base (- exp 1) m))
          m))))

;不用 square 而是直接用俩函数去乘，会导致重复递归
;原先的 square 写法每次折半，所以复杂度是 o(lgn)
;而这样写复杂度变为 o(lg(2^n))=o(n)
