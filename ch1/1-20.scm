;normal-order-evaluation
;21 remainders
(gcd 206 40)
(gcd 40 (remainder 206 40)) ;(gcd 40 6)
(gcd (remainder 206 40) (remainder 40 (remainder 206 40))) ;(gcd 6 4)
(gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))) ;(gcd 4 2)
(gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))) ;(gcd 2 0)

;applicative-order-evaluation
;4 remainders
(gcd 206 40)
(gcd 40 (remainder 206 40))
(gcd 40 6)
(gcd 6 (remainder 40 6))
(gcd 6 4)
(gcd 4 (remainder 6 4))
(gcd 4 2)
(gcd 2 (remainder 4 2))
(gcd 2 0)
