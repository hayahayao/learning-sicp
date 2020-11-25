;仿照二元组的实现，可以定义以下步骤：
;生成所有的相异三元组 unique-triples
;过滤条件：三元组的三个元之和等于 sum

(define (unique-pairs n)
  (flatmap (lambda (i)
             (map (lambda (j) (list i j))
                  (enumerate-interval 1 (- i 1))))
           (enumerate-interval 1 n)))
(define (unique-triples n)
  (flatmap (lambda (i)
             (map (lambda (j) (cons i j))
                  (unique-pairs (- i 1))))
           (enumerate-interval 1 n)))

(define (triple-sum-equal-to? sum triple)
  (= sum (fold-right + 0 triple))

(define (sum-triples n s)
  (filter (lambda (triple) (triple-sum-equal-to? s triple))
          (unique-triples n)))
