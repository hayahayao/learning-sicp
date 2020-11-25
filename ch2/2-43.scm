;origin
(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
          (lambda (positions) (safe? k positions))
          (flatmap
            (lambda (rest-of-queens)
              (map (lambda (new-row) (adjoin-position new-row k rest-of-queens))
                   (enumerate-interval 1 board-size)))
            (queen-cols (- k 1))))))
  (queen-cols board-size))

;louis's code
(flatmap
 (lambda (new-row)
   (map (lambda (rest-of-queens)
          (adjoin-position 
           new-row k rest-of-queens))
        (queen-cols (- k 1))))
 (enumerate-interval 1 board-size))

;区别在于计算 positions 的过程中，louis 交换了两个 map 的顺序
;原版对于每个 (queen-cols (- k 1))，生成了 board-size 个新棋盘
;louis 的版本则是对于每个 (enumerate-interval 1 board-size)，都要生成 (queen-cols (- k 1)) 个棋盘
;也就是说原版调了一次 (queen-cols (- k 1))，而后面的版本调了 board-size 次
;以下参考http://community.schemewiki.org/?sicp-ex-2.43
;Q(k) 表示 (queen-cols k) 得到的解的个数，T(k) 表示计算出 Q(k) 所用时间
;则原版：T(k) = T(k-1) + n * Q(k-1)
;louis：T(k) = n * (T(k-1) + Q(k-1))
;所以 louis 是原版的 n^2 倍
