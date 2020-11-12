(define (deep-reverse x)
  (if (pair? x) ;非叶子节点 则递归反转左右子树
      (append (deep-reverse (cdr x))
              (list (deep-reverse (car x))))
      x))
