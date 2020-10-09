;recursive
(define (fast-multi a b)
  (cond ((= b 0) 0)
        ((even? b)
         (double (fast-multi a (halve b))))
        (else
         (+ a (fast-multi a (- b 1)))))

;iterative
(define (fast-multi a b)
 (fm-iter a b 0))
(define (fm-iter a b product)
 (cond ((= b 0) product)
       ((even? b)
        (fm-iter (duoble a) (halve b) product))
       (else
        (fm-iter a (- b 1) (+ a product)))))
