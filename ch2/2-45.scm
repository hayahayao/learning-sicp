(define (split op1 op2)
  (define (recursive painter n)
    (if (= n 0)
        painter
        (let ((smaller (recursive painter (- n 1))))
          (op1 painter (op2 smaller smaller)))))
  recursive)
