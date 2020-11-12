(define x (list 1 2 3))
(define y (list 4 5 6))

(append x y) ;(1 2 3 4 5 6)
(cons x y) ;((1 2 3) 4 5 6)
(list x y) ;((1 2 3) (4 5 6))

;注意区别 cons 和 list
;(cons x y)
;(list x y) = (cons x (cons y nil)) 给 y 又包了一层
