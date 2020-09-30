;一个普通 procedure 版本的 if 定义
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

;当我们试图把这个 new-if 用于 ch1.1.7 中的求平方根过程中，会发生什么？
;let's try

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
    guess
    (sqrt-iter (improve guess x) x)))

;oops
;Aborting!: maximum recursion depth exceeded

;原来的 if 是个 special form，两个 clause 只会有一个被求值
;而 new-if 作为 ordinary procedure，两个 clause 都会被求值，所以递归调用爆栈了

;一个简单的例子
(if #t (display "good") (display "bad"))
;good
(new-if #t (display "good") (display "bad"))
;badgood <- 两个都输出了！
