(define counter 0)
(define (cube x) (* x x x))
(define (p x) 
  (set! counter (+ counter 1))
  (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))
(sine 12.15)
(display counter)

;(sine 12.15) 5次
;(sine a) 的时间复杂度取决于 a/3 何时满足 < 0.1
;也就是 o(lgn)
;每次运行 p 时占用一次空间，所以空间复杂度也是 o(lgn)
