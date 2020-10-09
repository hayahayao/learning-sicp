(define (count-change amount)
  (cc amount 5))
(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0)
             (= kinds-of-coins 0))
         0)
        (else
         (+ (cc amount (- kinds-of-coins 1))
            (cc (- amount (first-denomination kind-of-coins))
                kinds-of-coins)))))
(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-conis 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-conis 4) 25)
        ((= kinds-of-coins 5) 50)))

;空间复杂度随着递归栈的深度变化，最深会达到 n 层，即空间复杂度为 o(n)
;时间复杂度为 o(n^5)，证明见 https://codology.net/post/sicp-solution-exercise-1-14/
;可以通过剪枝的办法进行优化，对于 kinds-of-coins = 1/2/3 都可以直接给出计算结果避免反复递归
