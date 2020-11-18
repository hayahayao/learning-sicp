;accumulate/fold-right
;递归到底是initial，然后从sequence最后一个元素开始慢慢往前包
(define (fold-right op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
;fold-left
;每次取rest的第一个逐渐往后包
(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(fold-right / 1 (list 1 2 3)) ;1/(2/(3/1)) = 3/2
(fold-left  / 1 (list 1 2 3)) ;((1/1)/2)/3 = 1/6
(fold-right list nil (list 1 2 3)) ;(list 1 (list 2 (list 3 nil))) = (1 (2 (3 ())))
(fold-left  list nil (list 1 2 3)) ;(list (list (list nil 1) 2) 3) = (((() 1) 2) 3)

;op应当满足交换律和结合律
;http://community.schemewiki.org/?sicp-ex-2.38
