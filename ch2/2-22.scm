;题目中给出的迭代版本，这个版本会得到 reversed 的列表
;因为迭代最初值是空列表，相当于不断把 items 的最头元素推到 answer 中，所以越靠前的 items 越被推到后面
;与递归版本不同的是，“推”这个过程是每步即时执行的，因为每步里的 answer 都是确定的，不用等待递归执行结束的结果..
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items nil))

;给出的 fix 版本
;这个版本的顺序对了，但是组出来的列表是 (cons (cons (cons nil 1) 2 ) 3) 这种形式的，与标准的 (cons 1 (cons 2 (cons 3 nil))) 反了..
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))

;solution
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        (reverse answer)
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items nil))
;or..
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter (reverse items) nil))
;这两种解法都额外增加了一次 o(n) 的 reverse 调用操作，不过 square-list 的总复杂度还是 o(n)
