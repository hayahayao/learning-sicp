(define (* a b)
  (if (= b 0)
      0
      (+ a (* a (- b 1)))))

(define (fast-multi a b)
  (cond ((= b 0) 0)
        ((even? b)
         (double (fast-multi a (halve b))))
        (else
         (+ a (fast-multi a (- b 1)))))
