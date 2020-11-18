;sequence 长这样：(cons 1 (cons 2 (cons 3 (cons 4))))
;y 是已经转好的：(cons 4 (cons 3)), x=2
;希望得到的：(cons 4 (cons 3 (cons 2)))
(define (reverse sequence)
  (fold-right 
   (lambda (x y) (append y (list x))) nil sequence))
;y是已经转好的：(cons 2 (cons 1)), x=3
;希望得到的：(cons 3 (cons 2 (cons 1)))
(define (reverse sequence)
  (fold-left 
   (lambda (x y) (cons x y)) nil sequence))
