(define (f g) (g 2))
(f square) ;(square 2)=4
(f (lambda (z) (* z (+ z 1)))) ;(* 2 (+ 2 1))=6

(f f) ;(f 2)=(2 2)
;The object 2 is not applicable.
