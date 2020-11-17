(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) ;y 是已经执行过 p 的
              nil
              sequence))

;seq2 在后面，不断往前包 cons
;递归到底（seq2）然后再向上冒.. 
(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

;与 map 类似
(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))
