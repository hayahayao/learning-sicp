;map in scheme
;http://sarabander.github.io/sicp/html/2_002e2.xhtml#Footnote-78

;number[], number[] => number
(define (dot-product v w)
  (accumulate + 0 (map * v w)))

;number[number[]], number[] => number[]
(define (matrix-*-vector m v)
  (map (lambda (mi) (accumulate + 0 (doc-product mi v))) m))

;number[number[]] => number[number[]]
(define (transpose mat) ;a
  (accumulate-n cons nil mat)) 
;在 accumulate-n 中 (map car seqs) 已经取出了第一列
;接下来只需要正常的把它放到第一行就好了

;number[number[]], number[number[]] => number[number[]]
(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (mi) (matrix-*-vector cols mi)) m)))
;这个 map 中传入的 lambda: number[] => number[]（输入 m 的每行，输出结果矩阵的每行）
;给定的公式 p_ij = sum_k(m_ik * n_kj)
;那么对于 lambda 中的 mi 来说，i 固定，也就变成了 pi_j = sum_k(mi_k * n_kj)
;啊，就是 matrix-*-vector
;（结合矩阵象形理解会好一些...）
