;Church numerals
(define zero (lambda (f) (lambda (x) (x))))
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

;umm, let's try
(add-1 zero)
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) (x))) f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) (x)) x))))
(lambda (f) (lambda (x) (f x)))

;so, one = zero + 1
(define one
  (lambda (f)
    (lambda (x)
      (f x))))
;two = one + 1
(add-1 one)
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) (f x))) f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) (f x)) x))))
(lambda (f) (lambda (x) (f (f x))))
(define two
  (lambda (f)
    (lambda (x)
      (f (f x)))))

;观察 zero one two 的定义，只有函数体中调用 f 的次数不同
;我们有理由相信，后面的数也是这样..
;继续推广，那两个 Chruch 数相加，和就等于累积起两个过程中的 f 调用
(define +
  (lambda (m)
    (lambda (n)
      (lambda (f)
        (lambda (x)
          (m f (n f x)))))))
