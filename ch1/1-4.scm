(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

;(a-plus-abs-b 1 2)
(a-plus-abs-b 1 2)

((if (> 2 0) + -) 1 2)

((if #t + -) 1 2)

(+ 1 2)

;(a-plus-abs-b 1 -2)
(a-plus-abs-b 1 (- 2))

((if (> (- 2) 0) + -) 1 (- 2))

((if #f + -) 1 (- 2))

(- 1 (- 2))
