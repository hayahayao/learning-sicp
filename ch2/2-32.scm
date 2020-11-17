(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest
                (map (lambda (x) (cons (car s) x)) 
                     rest)))))

;http://community.schemewiki.org/?sicp-ex-2.32
;the set of all subsets of a given set is the union of:
;- the set of all subsets excluding the first number (rest)
;- the set of all subsets excluding the first number, with the first number re-inserted into each subset
;  这部分即为 map rest 的部分，将第一个数字加入 rest 的每一项
