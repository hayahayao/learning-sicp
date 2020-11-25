;八皇后问题
;递归：按列挨个放，放到第 k 列时前 k-1 都已经放好，只需要保证第 k 列这个不与之前的冲突
;也就是挨个放并检查，留下可行的作为一种方案，然后继续放...
(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
          (lambda (positions) (safe? k positions)) ;k 放好了之后是否不冲突
          (flatmap
            (lambda (rest-of-queens) ;rest-of-queens: k-1的结果
              (map (lambda (new-row) (adjoin-position new-row k rest-of-queens)) ;new-row: k 可能放的位置
                   (enumerate-interval 1 board-size)))
            (queen-cols (- k 1))))))
  (queen-cols board-size))

;先定义一下 queens 的输出，应该是: queen[]
;再定义 queen: number[]（长度为 board-size，其中第 i 项表示倒数第 i 行放置的位置(0-7)）
(define (adjoin-position new-row k rest-of-queens)
  (cons new-row rest-of-queens)) ;注意这里是倒序

(define (empty-board) nil)

(define (safe? k positions)
  (define (iter row-of-new-queen rest-of-queens i) ;这个 i 是用来算斜着是否冲突的
    (if (null? rest-of-queens)
        #t
        (let ((row-of-current-queen (car rest-of-queens)))
          (if (or (= row-of-new-queen row-of-current-queen)
                  (= row-of-new-queen (+ row-of-current-queen i))
                  (= row-of-new-queen (- row-of-current-queen i)))
              #f
              (iter row-of-new-queen
                    (cdr rest-of-queens)
                    (+ i 1)))))))
