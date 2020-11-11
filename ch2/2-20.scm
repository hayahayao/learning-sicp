(define (same-parity first . rest)
  (define (iter first rest result)
    (if (null? rest)
        result
        (let ((remainder-val (remainder first 2))
              (cur (car rest)))
          (iter first 
                (cdr rest)
                (if (= remainder-val (remainder cur 2))
                    (append result (list cur))
                    result)))))
  (iter first rest (list first)))
