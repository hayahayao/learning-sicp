(define (width i) (- (upper-bound i) (lower-bound i)))

(define (add-interval x y)
  (make-interval (+ (lower-bound x)
                    (lower-bound y))
                 (+ (upper-bound x)
                    (upper-bound y))))

(width (add-interval x y))
(width
  (make-interval (+ (lower-bound x)
                    (lower-bound y))
                 (+ (upper-bound x)
                    (upper-bound y))))
(width
  (cons (+ (car x) (car y))
        (+ (cdr x) (cdr y))))
(- (upper-bound (cons (+ (car x) (car y)) (+ (cdr x) (cdr y))))
   (lower-bound (cons (+ (car x) (car y)) (+ (cdr x) (cdr y)))))
(- (cdr (cons (+ (car x) (car y)) (+ (cdr x) (cdr y))))
   (car (cons (+ (car x) (car y)) (+ (cdr x) (cdr y)))))
(- (+ (cdr x) (cdr y)) (+ (car x) (car y)))
(- (cdr (+ x y)) (car (+ x y)))
(width (+ x y))

;用数学公式更好解释一些..
;乘法的话就不是相加了，举个例就知道..
