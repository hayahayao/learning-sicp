(define (make-point x y) (cons x y))
(define (x-point point) (car point))
(define (y-point point) (cdr point))

(define (make-segment start end) (cons start end))
(define (start-segment line) (car line))
(define (end-segment line) (cdr line))

(define (midpoint-segment line)
  (make-point 
    (average (x-point (start-segment line)) (x-point (end-segment line)))
    (average (y-point (start-segment line)) (y-point (end-segment line)))))
